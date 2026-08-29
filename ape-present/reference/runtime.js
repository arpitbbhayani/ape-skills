// ape-present runtime. Copy verbatim into the <script> at the end of <body>.
// Covers: figure reveals, stat counters, live diagram motion (packets, pulses,
// cycles) gated on visibility, and theme following. Idempotent: safe to run
// again if the host reloads the frame.
(() => {
  if (window.__apePresent) return;
  window.__apePresent = true;

  const root = document.documentElement;
  const reduced = matchMedia('(prefers-reduced-motion: reduce)').matches;

  // --- Theme --------------------------------------------------------------
  // Follow the OS via CSS; `t` flips it and the choice is remembered.
  {
    try { const saved = localStorage.getItem('ape-theme'); if (saved) root.setAttribute('data-theme', saved); } catch (_) {}
    addEventListener('keydown', (e) => {
      if (e.key !== 't' || e.metaKey || e.ctrlKey || e.altKey) return;
      if (e.target && /INPUT|TEXTAREA/.test(e.target.tagName)) return;
      const dark = root.getAttribute('data-theme') === 'dark' ||
        (!root.hasAttribute('data-theme') && matchMedia('(prefers-color-scheme: dark)').matches);
      const next = dark ? 'light' : 'dark';
      root.setAttribute('data-theme', next);
      try { localStorage.setItem('ape-theme', next); } catch (_) {}
    });
  }

  // --- Counters -----------------------------------------------------------
  // <span class="num" data-to="3200" data-suffix="x" data-decimals="1">0</span>
  const countUp = (el) => {
    if (el.dataset.done) return;
    el.dataset.done = '1';
    const to = parseFloat(el.dataset.to);
    const decimals = parseInt(el.dataset.decimals || '0', 10);
    const fmt = (v) => (el.dataset.prefix || '') + v.toLocaleString(undefined, {
      minimumFractionDigits: decimals, maximumFractionDigits: decimals,
    }) + (el.dataset.suffix || '');
    if (reduced) { el.textContent = fmt(to); return; }
    const start = performance.now(), dur = 1200;
    const tick = (now) => {
      const p = Math.min(1, (now - start) / dur);
      el.textContent = fmt(to * (1 - Math.pow(1 - p, 3)));
      if (p < 1) requestAnimationFrame(tick);
    };
    requestAnimationFrame(tick);
  };

  // --- Reveal once ----------------------------------------------------------
  // Figures, stat rows and the summary fade in when 20% visible, then stay.
  const targets = [...document.querySelectorAll('figure, .stats, .summary')];
  const io = new IntersectionObserver((entries) => {
    for (const e of entries) {
      if (!e.isIntersecting) continue;
      e.target.classList.add('in');
      e.target.querySelectorAll('.num[data-to]').forEach(countUp);
      io.unobserve(e.target);
    }
  }, { threshold: 0.2 });
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
  document.querySelectorAll('figure').forEach((f) => live.observe(f));

  // --- Cycles: [data-cycle="900"] lights its children in turn, forever ------
  document.querySelectorAll('[data-cycle]').forEach((host) => {
    const kids = [...host.children];
    if (kids.length < 2) return;
    const step = parseInt(host.dataset.cycle, 10) || 900;
    let i = 0;
    if (reduced) { kids[0].classList.add('lit'); return; }
    setInterval(() => {
      if (!host.closest('.live')) return;
      kids.forEach((k) => k.classList.remove('lit'));
      kids[i % kids.length].classList.add('lit');
      i++;
    }, step);
  });
})();
