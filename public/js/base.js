// Comportamiento común a toda la tienda: menú lateral, buscador con
// sugerencias, favoritos, agregar al carrito desde las tarjetas,
// avisos, cookies y aparición al hacer scroll.
(() => {
  const $ = (s, r = document) => r.querySelector(s);
  const $$ = (s, r = document) => [...r.querySelectorAll(s)];

  // ── Utilidades que usan las demás páginas ───────────────
  const peso = (n) => "$" + Math.round(n).toLocaleString("es-AR");
  let tTimer;
  function toast(mensaje, tipo) {
    const el = $("#toast");
    if (!el) return;
    el.textContent = mensaje;
    el.classList.toggle("toast--error", tipo === "error");
    el.classList.add("visible");
    clearTimeout(tTimer);
    tTimer = setTimeout(() => el.classList.remove("visible"), 3200);
  }
  // Pedido JSON al servidor: devuelve { ok, ...datos } sin tirar error
  async function pedir(url, { metodo = "GET", datos } = {}) {
    try {
      const r = await fetch(url, {
        method: metodo,
        headers: { Accept: "application/json", ...(datos ? { "Content-Type": "application/json" } : {}) },
        body: datos ? JSON.stringify(datos) : undefined,
      });
      const json = await r.json().catch(() => ({}));
      return { ok: r.ok && json.ok !== false, status: r.status, ...json };
    } catch {
      return { ok: false, mensaje: "No hay conexión. Probá de nuevo." };
    }
  }
  // El carrito tiene contador arriba y en la barra inferior
  function contadorCarrito(n) {
    $$("[data-contador-carrito]").forEach((el) => {
      el.textContent = n;
      el.animate([{ transform: "scale(1.5)" }, { transform: "scale(1)" }], { duration: 300, easing: "ease-out" });
    });
  }
  // Nombre heredado del proyecto base: lo usan carrito.js, producto.js, etc.
  window.VELT = window.FRESSIA = { $, $$, peso, toast, pedir, contadorCarrito };

  // ── Flash (mensaje de un solo uso del servidor) ──────────
  const flash = $("#flash");
  if (flash) toast(flash.dataset.mensaje);

  // ── Barra de anuncios: un mensaje por vez ───────────────
  const anuncio = $("[data-anuncio]");
  const mensajes = anuncio ? $$(".anuncio__item", anuncio) : [];
  if (mensajes.length > 1) {
    let i = 0;
    setInterval(() => {
      if (document.hidden) return;
      const actual = mensajes[i];
      i = (i + 1) % mensajes.length;
      const siguiente = mensajes[i];
      actual.classList.remove("is-activo");
      actual.classList.add("is-saliendo");
      actual.setAttribute("aria-hidden", "true");
      siguiente.classList.remove("is-saliendo");
      siguiente.classList.add("is-activo");
      siguiente.removeAttribute("aria-hidden");
      // Cuando termina de salir, vuelve abajo para la próxima vuelta
      setTimeout(() => actual.classList.remove("is-saliendo"), 650);
    }, 4000);
  }

  // ── Menú lateral (celular y tablet) ──────────────────────
  const btnMenu = $("#btnMenu");
  const drawerFondo = $("#drawerFondo");
  const abrirMenu = () => {
    document.body.classList.add("drawer-abierto");
    btnMenu?.setAttribute("aria-expanded", "true");
    if (drawerFondo) drawerFondo.hidden = false;
  };
  const cerrarMenu = () => {
    document.body.classList.remove("drawer-abierto");
    btnMenu?.setAttribute("aria-expanded", "false");
    if (drawerFondo) drawerFondo.hidden = true;
  };
  btnMenu?.addEventListener("click", abrirMenu);
  $("#btnCerrarMenu")?.addEventListener("click", cerrarMenu);
  drawerFondo?.addEventListener("click", cerrarMenu);
  $$("#drawer a").forEach((a) => a.addEventListener("click", cerrarMenu));

  // ── Menú de la cuenta ────────────────────────────────────
  const cuentaBtn = $("#cuentaBtn");
  const cuentaMenu = $("#cuentaMenu");
  cuentaBtn?.addEventListener("click", (e) => {
    e.stopPropagation();
    const abrir = cuentaMenu.hidden;
    cuentaMenu.hidden = !abrir;
    cuentaBtn.setAttribute("aria-expanded", String(abrir));
  });
  document.addEventListener("click", (e) => {
    if (cuentaMenu && !cuentaMenu.hidden && !cuentaMenu.contains(e.target)) {
      cuentaMenu.hidden = true;
      cuentaBtn.setAttribute("aria-expanded", "false");
    }
  });

  // ── Buscador con sugerencias ─────────────────────────────
  const buscador = $("#buscador");
  const input = $("#busquedaInput");
  const lista = $("#sugerencias");
  const esc = (t) => String(t).replace(/[&<>"']/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]));
  const mostrarSugerencias = (si) => {
    if (!lista) return;
    lista.hidden = !si;
    input.setAttribute("aria-expanded", String(si));
  };
  let tBusq, abortar;
  input?.addEventListener("input", () => {
    clearTimeout(tBusq);
    const q = input.value.trim();
    if (q.length < 2) return mostrarSugerencias(false);
    tBusq = setTimeout(async () => {
      abortar?.abort();
      abortar = new AbortController();
      try {
        const r = await fetch(`/buscar/sugerencias?q=${encodeURIComponent(q)}`, { signal: abortar.signal }).then((x) => x.json());
        lista.innerHTML = r.productos.length
          ? r.productos.map((p) => `
              <a class="sugerencia" href="/producto/${p.id}">
                <img src="${esc(p.imagen || "")}" alt="">
                <span><span class="sugerencia__nombre">${esc(p.nombre)}</span><br><span class="sugerencia__cat">${esc(p.categoria)}${p.sinStock ? " · Agotado" : ""}</span></span>
                <span class="sugerencia__precio">${peso(p.precio)}</span>
              </a>`).join("") +
            (r.total > r.productos.length ? `<a class="sugerencias__todos" href="/buscar?q=${encodeURIComponent(q)}">Ver los ${r.total} resultados →</a>` : "")
          : `<p class="sugerencias__vacio">No encontramos “${esc(q)}”. Probá con otra palabra.</p>`;
        mostrarSugerencias(true);
      } catch {}
    }, 180);
  });
  input?.addEventListener("focus", () => { if (lista?.innerHTML.trim() && input.value.trim().length >= 2) mostrarSugerencias(true); });

  // En PC el buscador se despliega con el botón "Buscar" del header
  const header = $("#header");
  const btnBuscar = $("#btnBuscar");
  const cerrarBuscador = () => {
    header?.classList.remove("buscando");
    btnBuscar?.setAttribute("aria-expanded", "false");
  };
  btnBuscar?.addEventListener("click", (e) => {
    e.stopPropagation();
    const abrir = !header.classList.contains("buscando");
    header.classList.toggle("buscando", abrir);
    btnBuscar.setAttribute("aria-expanded", String(abrir));
    if (abrir) setTimeout(() => input?.focus(), 60);
  });
  document.addEventListener("click", (e) => {
    if (buscador && !buscador.contains(e.target)) { mostrarSugerencias(false); cerrarBuscador(); }
  });

  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape") { mostrarSugerencias(false); cerrarBuscador(); cerrarMenu(); cerrarHoja(); }
    // Atajo: "/" lleva al buscador
    if (e.key === "/" && input && !/input|textarea|select/i.test(document.activeElement.tagName)) {
      e.preventDefault();
      header?.classList.add("buscando");
      input.focus();
    }
  });

  // ── Favoritos (corazón en tarjetas y fichas) ─────────────
  document.addEventListener("click", async (e) => {
    const btn = e.target.closest("[data-fav]");
    if (!btn) return;
    e.preventDefault();
    const r = await pedir(`/favoritos/${btn.dataset.fav}`, { metodo: "POST" });
    if (!r.ok) return toast(r.mensaje || "No se pudo guardar", "error");
    btn.setAttribute("aria-pressed", String(r.activo));
    const c = $("#contadorFavoritos");
    if (c) { c.textContent = r.cantidad; c.hidden = !r.cantidad; }
    toast(r.activo ? "Guardado en favoritos" : "Quitado de favoritos");
    document.dispatchEvent(new CustomEvent("velt:favorito", { detail: { id: btn.dataset.fav, ...r } }));
  });

  // ── Agregar al carrito desde una tarjeta ─────────────────
  // Sin talles o con uno solo se agrega directo; con varios, se elige en una hoja.
  const hoja = $("#hojaTalle");
  const hojaFondo = $("#hojaFondo");
  let botonOrigen = null;
  function cerrarHoja() {
    if (!hoja || hoja.hidden) return;
    hoja.hidden = true;
    hojaFondo.hidden = true;
    botonOrigen?.focus();
  }
  async function agregar(boton, talle) {
    boton.classList.add("is-cargando");
    const r = await pedir("/carrito/agregar", { metodo: "POST", datos: { id: boton.dataset.agregar, cantidad: 1, talle } });
    boton.classList.remove("is-cargando");
    if (!r.ok) return toast(r.mensaje || "No se pudo agregar", "error");
    contadorCarrito(r.cantidad);
    toast(`${boton.dataset.nombre}${talle ? " (" + talle + ")" : ""} se agregó al carrito`);
  }
  document.addEventListener("click", (e) => {
    const boton = e.target.closest("[data-agregar]");
    if (!boton) return;
    const talles = (boton.dataset.talles || "").split(",").filter(Boolean);
    if (talles.length <= 1 || !hoja) return agregar(boton, talles[0]);

    botonOrigen = boton;
    $("#hojaTitulo").textContent = boton.dataset.nombre;
    $("#hojaFicha").href = `/producto/${boton.dataset.agregar}`;
    const cont = $("#hojaTalles");
    cont.innerHTML = talles.map((t) => `<button type="button" data-talle="${esc(t)}">${esc(t)}</button>`).join("");
    hoja.hidden = false;
    hojaFondo.hidden = false;
    cont.querySelector("button")?.focus();
  });
  $("#hojaTalles")?.addEventListener("click", (e) => {
    const t = e.target.closest("[data-talle]");
    if (!t || !botonOrigen) return;
    const origen = botonOrigen;
    cerrarHoja();
    agregar(origen, t.dataset.talle);
  });
  $("#hojaCerrar")?.addEventListener("click", cerrarHoja);
  hojaFondo?.addEventListener("click", cerrarHoja);

  // ── Mostrar / ocultar contraseña ─────────────────────────
  document.addEventListener("click", (e) => {
    const b = e.target.closest("[data-ver-clave]");
    if (!b) return;
    const campo = b.parentElement.querySelector("input");
    const ver = campo.type === "password";
    campo.type = ver ? "text" : "password";
    b.textContent = ver ? "Ocultar" : "Ver";
    b.setAttribute("aria-label", ver ? "Ocultar contraseña" : "Mostrar contraseña");
  });

  // ── Cookies ──────────────────────────────────────────────
  const cookies = $("#avisoCookies");
  try {
    if (cookies && !localStorage.getItem("fressia-cookies")) cookies.hidden = false;
    $("#aceptarCookies")?.addEventListener("click", () => { localStorage.setItem("fressia-cookies", "1"); cookies.hidden = true; });
  } catch {}

  // ── Aparición al hacer scroll ────────────────────────────
  const aparecer = (raiz = document) => {
    const nodos = $$(".rev:not(.visto)", raiz);
    if (!("IntersectionObserver" in window)) return nodos.forEach((n) => n.classList.add("visto"));
    const o = new IntersectionObserver((es) => es.forEach((x) => { if (x.isIntersecting) { x.target.classList.add("visto"); o.unobserve(x.target); } }), { rootMargin: "0px 0px -6% 0px", threshold: 0.08 });
    nodos.forEach((n) => o.observe(n));
  };
  window.VELT.aparecer = aparecer;
  aparecer();
})();
