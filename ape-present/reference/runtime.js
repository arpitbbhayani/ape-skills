// ape-present runtime. Copy verbatim into the <script> at the end of <body>.
// Covers: figure reveals, stat counters, live diagram motion (packets, pulses,
// cycles, streaming channels), meter animations, inspect-node cross-highlighting,
// interactive step-by-step walkthroughs, and theme switching.
(() => {
  if (window.__apePresent) return;
  window.__apePresent = true;

  const root = document.documentElement;
  const reduced = matchMedia('(prefers-reduced-motion: reduce)').matches;

  // --- Theme --------------------------------------------------------------
  {
    // The theme the document was built with (data-theme on <html>, or none = follow OS).
    const builtTheme = root.getAttribute('data-theme');
    const DARK = ['midnight', 'dark', 'mocha', 'tokyo', 'tokyo-night', 'nord', 'dracula',
      'gruvbox', 'rosepine', 'rose-pine', 'forest', 'neon'];
    // Scoped per document so toggling one doc never restyles another on the same origin.
    const KEY = 'ape-theme:' + (location.pathname.split('/').pop() || 'doc');

    const applyTheme = (t) => {
      if (!t) return;
      root.setAttribute('data-theme', t);
      try { localStorage.setItem(KEY, t); } catch (_) {}
    };

    try {
      const saved = localStorage.getItem(KEY);
      if (saved) root.setAttribute('data-theme', saved);
    } catch (_) {}

    window.addEventListener('message', (e) => {
      if (e && e.data && e.data.type === 'theme' && e.data.theme) {
        applyTheme(e.data.theme);
      }
    });

    try {
      if (window.parent && window.parent !== window && window.parent.document && window.parent.document.documentElement) {
        const parentTheme = window.parent.document.documentElement.getAttribute('data-theme');
        if (parentTheme) root.setAttribute('data-theme', parentTheme);
      }
    } catch (_) {}

    // `t` flips polarity but remembers the built theme: a nord document goes
    // nord -> daylight -> nord, not nord -> midnight.
    addEventListener('keydown', (e) => {
      if (e.key !== 't' || e.metaKey || e.ctrlKey || e.altKey) return;
      if (e.target && /INPUT|TEXTAREA/.test(e.target.tagName)) return;
      const cur = root.getAttribute('data-theme');
      const isDark = cur ? DARK.includes(cur)
        : matchMedia('(prefers-color-scheme: dark)').matches;
      const darkHome = builtTheme && DARK.includes(builtTheme) ? builtTheme : 'midnight';
      const lightHome = builtTheme && !DARK.includes(builtTheme) ? builtTheme : 'daylight';
      applyTheme(isDark ? lightHome : darkHome);
    });
  }

  // --- Counters -----------------------------------------------------------
  const countUp = (el) => {
    if (el.dataset.done) return;
    el.dataset.done = '1';
    const to = parseFloat(el.dataset.to);
    const decimals = parseInt(el.dataset.decimals || '0', 10);
    const fmt = (v) => (el.dataset.prefix || '') + v.toLocaleString(undefined, {
      minimumFractionDigits: decimals, maximumFractionDigits: decimals,
    }) + (el.dataset.suffix || '');
    if (reduced || isNaN(to)) { el.textContent = fmt(isNaN(to) ? 0 : to); return; }
    const start = performance.now(), dur = 1200;
    const tick = (now) => {
      const p = Math.min(1, (now - start) / dur);
      el.textContent = fmt(to * (1 - Math.pow(1 - p, 3)));
      if (p < 1) requestAnimationFrame(tick);
    };
    requestAnimationFrame(tick);
  };

  // --- Meter / Race Bars ----------------------------------------------------
  const animateMeter = (el) => {
    const pct = el.dataset.pct || el.style.getPropertyValue('--pct') || '0%';
    el.style.setProperty('--target-pct', pct);
    el.classList.add('filled');
  };

  // --- Reveal once ----------------------------------------------------------
  const targets = [...document.querySelectorAll('figure, .stats, .summary, .callout, .race-bars, .quadrant')];
  const io = new IntersectionObserver((entries) => {
    for (const e of entries) {
      if (!e.isIntersecting) continue;
      e.target.classList.add('in');
      e.target.querySelectorAll('.num[data-to]').forEach(countUp);
      e.target.querySelectorAll('.meter-fill, .race-fill').forEach(animateMeter);
      io.unobserve(e.target);
    }
  }, { threshold: 0.15 });
  targets.forEach((t) => io.observe(t));

  // --- Live motion: run only while the figure is on screen ------------------
  const live = new IntersectionObserver((entries) => {
    for (const e of entries) {
      e.target.classList.toggle('live', e.isIntersecting);
      e.target.querySelectorAll('svg').forEach((svg) => {
        if (reduced) { svg.pauseAnimations(); return; }
        e.isIntersecting ? svg.unpauseAnimations() : svg.pauseAnimations();
      });
    }
  }, { threshold: 0.1 });
  document.querySelectorAll('figure, .live-host').forEach((f) => live.observe(f));

  // --- Cycles: [data-cycle="900"] lights its children in turn, forever ------
  document.querySelectorAll('[data-cycle]').forEach((host) => {
    const kids = [...host.children];
    if (kids.length < 2) return;
    const step = parseInt(host.dataset.cycle, 10) || 900;
    let i = 0;
    if (reduced) { kids[0].classList.add('lit'); return; }
    setInterval(() => {
      if (!host.closest('.live') && !host.classList.contains('live')) return;
      kids.forEach((k) => k.classList.remove('lit'));
      kids[i % kids.length].classList.add('lit');
      i++;
    }, step);
  });

  // --- Inspect-Node Cross-Highlighting (Prose <-> Diagram) ------------------
  document.querySelectorAll('.inspect-node[data-target]').forEach((pill) => {
    const targetId = pill.dataset.target;
    const targetEl = document.getElementById(targetId);
    if (!targetEl) return;

    const svg = targetEl.closest('svg');

    const activate = () => {
      pill.classList.add('inspecting');
      if (svg) svg.classList.add('inspect-active');
      targetEl.classList.add('inspected');
    };

    const deactivate = () => {
      pill.classList.remove('inspecting');
      if (svg) svg.classList.remove('inspect-active');
      targetEl.classList.remove('inspected');
    };

    pill.addEventListener('mouseenter', activate);
    pill.addEventListener('mouseleave', deactivate);
    pill.addEventListener('focus', activate);
    pill.addEventListener('blur', deactivate);
    // Touch / click: toggle, so the highlight is reachable without hover or a keyboard.
    pill.addEventListener('click', () =>
      pill.classList.contains('inspecting') ? deactivate() : activate());
  });

  // --- Interactive Step-by-Step Steppers -----------------------------------
  document.querySelectorAll('.stepper').forEach((stepper) => {
    const panes = [...stepper.querySelectorAll('.step-pane')];
    const indicator = stepper.querySelector('.step-count');
    const prevBtn = stepper.querySelector('.step-prev');
    const nextBtn = stepper.querySelector('.step-next');
    const targetSvgId = stepper.dataset.svg;
    const svg = targetSvgId ? document.getElementById(targetSvgId) : null;
    let current = 0;

    const render = () => {
      panes.forEach((p, idx) => p.classList.toggle('active', idx === current));
      if (indicator) indicator.textContent = `${current + 1} / ${panes.length}`;
      if (prevBtn) prevBtn.disabled = current === 0;
      if (nextBtn) nextBtn.disabled = current === panes.length - 1;

      if (svg) {
        svg.querySelectorAll('[data-step]').forEach((el) => {
          const stepVal = parseInt(el.dataset.step, 10);
          el.classList.toggle('active-step', stepVal === current + 1);
        });
      }
    };

    if (prevBtn) prevBtn.addEventListener('click', () => { if (current > 0) { current--; render(); } });
    if (nextBtn) nextBtn.addEventListener('click', () => { if (current < panes.length - 1) { current++; render(); } });
    render();
  });
})();
