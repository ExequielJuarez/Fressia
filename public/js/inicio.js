// Inicio: carrusel principal.
// Pasa solo cada N segundos, con flechas, rayitas, teclado y deslizando
// con el dedo. Se pausa con el mouse encima o si la pestaña no se ve.
(() => {
  const carrusel = document.querySelector("[data-carrusel]");
  if (!carrusel) return;
  const slides = [...carrusel.querySelectorAll("[data-slide]")];
  const puntos = [...carrusel.querySelectorAll("[data-ir]")];
  if (slides.length < 2) return;

  const intervalo = Number(carrusel.dataset.intervalo) || 6000;
  const sinMovimiento = matchMedia("(prefers-reduced-motion: reduce)").matches;
  carrusel.style.setProperty("--duracion", `${intervalo}ms`);
  let actual = 0;
  let timer;

  function ir(n) {
    actual = (n + slides.length) % slides.length;
    slides.forEach((s, i) => {
      const activa = i === actual;
      s.classList.toggle("is-activa", activa);
      s.setAttribute("aria-hidden", String(!activa));
      // Solo el botón del banner visible se puede enfocar con Tab
      s.querySelectorAll("a").forEach((a) => (activa ? a.removeAttribute("tabindex") : a.setAttribute("tabindex", "-1")));
    });
    puntos.forEach((p, i) => {
      // Se reinicia la animación de la rayita
      p.classList.remove("is-activo");
      void p.offsetWidth;
      p.classList.toggle("is-activo", i === actual);
      p.setAttribute("aria-selected", String(i === actual));
    });
  }
  const parar = () => { clearInterval(timer); carrusel.classList.add("pausado"); };
  const arrancar = () => {
    clearInterval(timer);
    carrusel.classList.remove("pausado");
    if (!sinMovimiento) timer = setInterval(() => ir(actual + 1), intervalo);
  };
  const mover = (n) => { ir(n); arrancar(); };

  carrusel.querySelector("[data-anterior]")?.addEventListener("click", () => mover(actual - 1));
  carrusel.querySelector("[data-siguiente]")?.addEventListener("click", () => mover(actual + 1));
  puntos.forEach((p) => p.addEventListener("click", () => mover(Number(p.dataset.ir))));
  carrusel.addEventListener("mouseenter", parar);
  carrusel.addEventListener("mouseleave", arrancar);
  carrusel.addEventListener("focusin", parar);
  carrusel.addEventListener("focusout", arrancar);
  carrusel.addEventListener("keydown", (e) => {
    if (e.key === "ArrowLeft") mover(actual - 1);
    if (e.key === "ArrowRight") mover(actual + 1);
  });
  document.addEventListener("visibilitychange", () => (document.hidden ? parar() : arrancar()));

  // Deslizar con el dedo
  let x0 = null;
  carrusel.addEventListener("touchstart", (e) => { x0 = e.touches[0].clientX; parar(); }, { passive: true });
  carrusel.addEventListener("touchend", (e) => {
    if (x0 === null) return;
    const dx = e.changedTouches[0].clientX - x0;
    if (Math.abs(dx) > 40) ir(actual + (dx < 0 ? 1 : -1));
    x0 = null;
    arrancar();
  });

  ir(0);
  arrancar();
})();

// Inicio: video del local.
// Siempre en silencio y sin controles: se reproduce solo cuando la sección
// está a la vista y se pausa al salir (ahorra batería y datos).
// En PC el mismo video va desenfocado de fondo.
(() => {
  const seccion = document.querySelector('[data-local]');
  const video = seccion?.querySelector('[data-video-local]');
  if (!seccion || !video) return;
  const fondo = seccion.querySelector('.local__fondo');
  video.muted = true;

  // El fondo desenfocado solo se carga en pantallas grandes
  if (fondo && matchMedia('(min-width: 1100px)').matches) {
    fondo.src = fondo.dataset.src;
    fondo.addEventListener('canplay', () => fondo.classList.add('listo'), { once: true });
  }
  const reproducir = () => { video.play().catch(() => {}); if (fondo?.src) fondo.play().catch(() => {}); };
  const pausar = () => { video.pause(); fondo?.pause(); };

  if ('IntersectionObserver' in window) {
    new IntersectionObserver(([e]) => (e.isIntersecting ? reproducir() : pausar()), { threshold: 0.2 }).observe(seccion);
  } else reproducir();
})();
