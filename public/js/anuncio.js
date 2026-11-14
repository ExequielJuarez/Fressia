// Barra de anuncios: hojas llevadas por el viento.
// - Una brisa constante las arrastra de izquierda a derecha, balanceándose y dando vueltas.
// - Cada tantos segundos sopla una ráfaga: las ramas se sacuden, se desprenden hojas
//   de la rama izquierda y aparecen líneas de viento.
// - Al mover el mouse sobre la barra, el aire empuja las hojas cercanas.
// Se pausa si la barra no se ve o la pestaña está oculta, y respeta "reducir movimiento".
(() => {
  const barra = document.querySelector("[data-anuncio-barra]");
  const lienzo = barra?.querySelector("[data-lienzo]");
  if (!barra || !lienzo || !lienzo.getContext) return;
  const ctx = lienzo.getContext("2d");
  const sinMovimiento = matchMedia("(prefers-reduced-motion: reduce)").matches;

  // Formas de hoja (dibujadas en una caja de 24 × 24, centradas)
  const FORMAS = [
    new Path2D("M-10 0C-6-7 4-9 11 0 4 9-6 7-10 0z"), // ovalada
    new Path2D("M-11 0C-5-4 5-4 11 0 5 4-5 4-11 0z"), // alargada
    new Path2D("M0-10l2 4 4-2-1 4 4 1-3 3 2 3-4-1-1 4-2-3-2 3-1-4-4 1 2-3-3-3 4-1-1-4 4 2z"), // con puntas
    new Path2D("M-4-3a3 3 0 1 1 3-3 3 3 0 1 1 3 3 3 3 0 1 1-3 3 3 3 0 1 1-3-3z"), // pétalo de flor
  ];
  const NERVIO = new Path2D("M-9 0L10 0");
  const COLORES = ["#c29c6f", "#9aa77c", "#d6b48e", "#a57a4d", "#b9c49a", "#8f6b4e", "#e8c9b5"];

  let ancho = 0, alto = 0, dpr = 1;
  let hojas = [];
  let rachas = [];
  const raton = { x: -999, y: -999, vx: 0, vy: 0, dentro: false };
  const al = (a, b) => a + Math.random() * (b - a);

  function medir() {
    dpr = Math.min(window.devicePixelRatio || 1, 2);
    ancho = barra.clientWidth;
    alto = barra.clientHeight;
    lienzo.width = Math.round(ancho * dpr);
    lienzo.height = Math.round(alto * dpr);
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
  }
  const maximo = () => (ancho < 700 ? 8 : 16);

  // desdeRama: nace en la rama izquierda; si no, en un lugar cualquiera a la izquierda
  function nuevaHoja(desdeRama = false, x) {
    const forma = Math.random() < 0.18 ? 3 : Math.floor(Math.random() * 3);
    return {
      x: x ?? (desdeRama ? al(10, 130) : al(-40, -10)),
      y: desdeRama ? al(alto * 0.45, alto * 0.9) : al(4, alto - 4),
      vx: desdeRama ? al(0.2, 0.6) : al(0.4, 1),
      vy: al(-0.15, 0.15),
      tam: forma === 3 ? al(0.45, 0.6) : al(0.5, 0.85),
      peso: al(0.7, 1.3),
      giro: al(0, Math.PI * 2),
      vGiro: al(-0.05, 0.05),
      fase: al(0, Math.PI * 2),
      vFase: al(0.03, 0.07),
      forma,
      color: forma === 3 ? "#f0d6c4" : COLORES[Math.floor(Math.random() * COLORES.length)],
      alfa: desdeRama ? 0 : 0.9,
    };
  }

  // ── Ráfagas ──────────────────────────────────────────────
  let rafaga = 0; // intensidad 0..1
  let rafagaInicio = 0;
  let proximaRafaga = performance.now() + al(3500, 6000);
  const DURACION_RAFAGA = 2600;
  function soplar(ahora) {
    rafagaInicio = ahora;
    proximaRafaga = ahora + al(7000, 11000);
    barra.classList.add("en-rafaga");
    setTimeout(() => barra.classList.remove("en-rafaga"), DURACION_RAFAGA * 0.8);
    // Se desprenden hojas de la rama
    const n = ancho < 700 ? 3 : 6;
    for (let i = 0; i < n; i++) setTimeout(() => hojas.push(nuevaHoja(true)), i * 140);
    // Líneas de viento
    for (let i = 0; i < (ancho < 700 ? 2 : 4); i++) {
      rachas.push({ x: al(-ancho * 0.3, ancho * 0.4), y: al(6, alto - 6), largo: al(80, 180), vida: 0, dur: al(70, 110), onda: al(2, 5) });
    }
  }

  // ── Movimiento ───────────────────────────────────────────
  function actualizar(ahora) {
    if (ahora > proximaRafaga) soplar(ahora);
    const t = (ahora - rafagaInicio) / DURACION_RAFAGA;
    rafaga = t >= 0 && t <= 1 ? Math.sin(Math.PI * t) : 0;
    const viento = 0.7 + rafaga * 3.2;

    // Siempre hay algunas hojas en el aire
    if (hojas.length < maximo() && Math.random() < 0.025) hojas.push(nuevaHoja(Math.random() < 0.3));

    for (const h of hojas) {
      h.vx += (viento * h.peso - h.vx) * 0.025;
      h.vy += Math.sin(h.fase) * 0.012 + (alto * 0.55 - h.y) * 0.0006; // flota y tiende al centro
      h.fase += h.vFase * (1 + rafaga);
      h.giro += h.vGiro * (1 + rafaga * 3);
      // El aire que mueve el mouse
      if (raton.dentro) {
        const dx = h.x - raton.x, dy = h.y - raton.y;
        const d = Math.hypot(dx, dy);
        if (d < 70) {
          const f = (1 - d / 70) * 0.35;
          h.vx += raton.vx * f * 0.25 + (dx / (d || 1)) * f;
          h.vy += raton.vy * f * 0.25 + (dy / (d || 1)) * f;
          h.vGiro += (Math.random() - 0.5) * 0.02;
        }
      }
      h.vy *= 0.96;
      h.x += h.vx;
      h.y += h.vy;
      // Rebota suave contra el borde de arriba y de abajo
      if (h.y < 3) { h.y = 3; h.vy = Math.abs(h.vy) * 0.5; }
      if (h.y > alto - 3) { h.y = alto - 3; h.vy = -Math.abs(h.vy) * 0.5; }
      h.alfa = Math.min(0.92, h.alfa + 0.03);
    }
    hojas = hojas.filter((h) => h.x < ancho + 30 && h.x > -60);
    raton.vx *= 0.85;
    raton.vy *= 0.85;

    for (const r of rachas) { r.vida++; r.x += 3 + rafaga * 4; }
    rachas = rachas.filter((r) => r.vida < r.dur);
  }

  // ── Dibujo ───────────────────────────────────────────────
  function dibujar() {
    ctx.clearRect(0, 0, ancho, alto);

    // Líneas de viento: trazos ondulados que aparecen y se desvanecen
    ctx.lineCap = "round";
    for (const r of rachas) {
      const p = r.vida / r.dur;
      ctx.strokeStyle = `rgba(194, 156, 111, ${Math.sin(Math.PI * p) * 0.45})`;
      ctx.lineWidth = 1.1;
      ctx.beginPath();
      for (let i = 0; i <= 24; i++) {
        const x = r.x + (r.largo * i) / 24;
        const y = r.y + Math.sin(i / 3 + r.vida / 8) * r.onda * Math.sin((Math.PI * i) / 24);
        i ? ctx.lineTo(x, y) : ctx.moveTo(x, y);
      }
      ctx.stroke();
    }

    for (const h of hojas) {
      // "Volteo": la hoja se achata y se da vuelta como si girara en el aire
      const volteo = Math.cos(h.fase * 1.4);
      ctx.save();
      ctx.globalAlpha = h.alfa;
      ctx.translate(h.x, h.y);
      ctx.rotate(h.giro);
      ctx.scale(h.tam, h.tam * (0.25 + 0.75 * Math.abs(volteo)));
      ctx.fillStyle = h.color;
      ctx.fill(FORMAS[h.forma]);
      if (h.forma < 2) {
        ctx.strokeStyle = volteo > 0 ? "rgba(255,255,255,.55)" : "rgba(0,0,0,.12)";
        ctx.lineWidth = 1.1;
        ctx.stroke(NERVIO);
      }
      ctx.restore();
    }
  }

  // ── Bucle ────────────────────────────────────────────────
  let corriendo = false, visible = true, cuadro;
  function bucle(ahora) {
    actualizar(ahora);
    dibujar();
    cuadro = requestAnimationFrame(bucle);
  }
  const arrancar = () => {
    if (corriendo || sinMovimiento || !visible || document.hidden) return;
    corriendo = true;
    cuadro = requestAnimationFrame(bucle);
  };
  const parar = () => { corriendo = false; cancelAnimationFrame(cuadro); };

  medir();
  if (sinMovimiento) {
    // Sin animación: unas hojas quietas de adorno
    hojas = Array.from({ length: maximo() / 2 }, (_, i) => nuevaHoja(false, ((i + 0.5) * ancho) / (maximo() / 2)));
    dibujar();
    return;
  }
  // Arranca con hojas ya repartidas por la barra
  hojas = Array.from({ length: Math.ceil(maximo() * 0.6) }, () => nuevaHoja(false, al(0, ancho)));

  window.addEventListener("resize", medir);
  document.addEventListener("visibilitychange", () => (document.hidden ? parar() : arrancar()));
  if ("IntersectionObserver" in window) {
    new IntersectionObserver(([e]) => { visible = e.isIntersecting; visible ? arrancar() : parar(); }).observe(barra);
  }
  barra.addEventListener("pointermove", (e) => {
    const r = barra.getBoundingClientRect();
    const x = e.clientX - r.left, y = e.clientY - r.top;
    if (raton.dentro) { raton.vx = x - raton.x; raton.vy = y - raton.y; }
    raton.x = x; raton.y = y; raton.dentro = true;
  });
  barra.addEventListener("pointerleave", () => { raton.dentro = false; });
  arrancar();
})();
