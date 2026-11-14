// ==========================================================
// Qué se puede editar del inicio desde el panel (Admin → Inicio)
// y el valor original de cada cosa.
//
// Este esquema arma solo el formulario del panel, limpia lo que
// se guarda y completa lo que falta. Para sumar un campo nuevo
// alcanza con agregarlo acá y usarlo en views/inicio.ejs.
//
// Tipos: texto (una línea) · lineas (varios renglones) · parrafo
//        numero · link · imagen · opciones · lista (fija o variable)
// En los textos, *palabra* se resalta.
// ==========================================================

const FONDOS = { oscuro: "Oscuro", medio: "Gris", claro: "Claro" };

// Dónde va el texto sobre la foto del carrusel
const POSICIONES = { izquierda: "Izquierda", centro: "Centro", derecha: "Derecha" };

const texto = (etiqueta, defecto, max = 80, extra = {}) => ({ tipo: "texto", etiqueta, defecto, max, ...extra });
const parrafo = (etiqueta, defecto, max = 300, extra = {}) => ({ tipo: "parrafo", etiqueta, defecto, max, ...extra });
const link = (etiqueta, defecto, extra = {}) => ({ tipo: "link", etiqueta, defecto, max: 255, ancho: "medio", ...extra });
const imagen = (etiqueta, defecto, extra = {}) => ({ tipo: "imagen", etiqueta, defecto, ...extra });
const etiquetaSeccion = (defecto) => texto("Texto chico de arriba", defecto, 40);
const tituloSeccion = (defecto) =>
  texto("Título", defecto, 70, { ayuda: "Poné *entre asteriscos* la parte que queda resaltada." });

const SECCIONES = {
  portada: {
    titulo: "Carrusel principal",
    descripcion:
      "Los banners grandes que van pasando arriba de todo. Ideal: una foto horizontal por banner (1920 × 900). " +
      "Si cargás fotos verticales, poné 2 o 3 y se muestran una al lado de la otra.",
    siempreVisible: true,
    campos: {
      slides: {
        tipo: "lista",
        etiqueta: "Banners",
        item: "Banner",
        cantidad: 3,
        ayuda: "Un banner sin foto no se muestra.",
        campos: {
          imagen: imagen("Foto (horizontal) o primera foto", "", { fondo: "claro" }),
          imagen2: imagen("Segunda foto (opcional)", "", { ancho: "medio" }),
          imagen3: imagen("Tercera foto (opcional)", "", { ancho: "medio" }),
          etiqueta: texto("Texto chico", "", 40, { ancho: "medio" }),
          titulo: texto("Título", "", 60, { ancho: "medio", ayuda: "*Entre asteriscos* va en cursiva." }),
          botonTexto: texto("Botón", "", 30, { ancho: "medio" }),
          botonLink: link("Link del botón", ""),
          posicion: { tipo: "opciones", etiqueta: "Lugar del texto", opciones: POSICIONES, defecto: "centro" },
        },
        defecto: [
          {
            imagen: "/img/productos/vestido-luna-1.jpg",
            imagen2: "/img/productos/vestido-margarita-1.webp",
            imagen3: "/img/productos/vestido-cacao-1.jpg",
            etiqueta: "Nueva colección",
            titulo: "Vestidos de *verano*",
            botonTexto: "Descubrir",
            botonLink: "/categoria/vestidos",
            posicion: "centro",
          },
          {
            imagen: "/img/productos/top-sicilia-1.jpg",
            imagen2: "/img/productos/top-sol-1.jpg",
            imagen3: "/img/productos/musculosa-tejida-arena-1.jpg",
            etiqueta: "Moda que te acompaña",
            titulo: "Tops para *todos los días*",
            botonTexto: "Ver tops",
            botonLink: "/categoria/ropa?sub=tops",
            posicion: "centro",
          },
          {
            imagen: "/img/productos/blusa-romana-1.jpg",
            imagen2: "/img/productos/sweater-polo-rayado-1.jpg",
            imagen3: "/img/productos/buzo-estampado-cozy-1.jpg",
            etiqueta: "Hasta 6 cuotas",
            titulo: "Abrigate *con estilo*",
            botonTexto: "Ver novedades",
            botonLink: "/novedades",
            posicion: "centro",
          },
        ],
      },
    },
  },

  nuevos: {
    titulo: "Nuevos ingresos",
    descripcion: "Grilla de productos (se arma sola con lo último que cargaste con stock).",
    campos: {
      titulo: tituloSeccion("Nuevos ingresos"),
      cantidad: { tipo: "numero", etiqueta: "Cuántos mostrar", defecto: 8, max: 12, ancho: "medio" },
      linkTexto: texto("Texto del link", "Ver todo", 30, { ancho: "medio" }),
      linkUrl: link("A dónde lleva", "/novedades"),
    },
  },

  destacadas: {
    titulo: "Fotos destacadas",
    descripcion: "Dos fotos grandes, una al lado de la otra, que llevan a una sección.",
    campos: {
      items: {
        tipo: "lista",
        etiqueta: "Fotos",
        item: "Foto",
        cantidad: 2,
        campos: {
          imagen: imagen("Foto (vertical)", ""),
          titulo: texto("Título", "", 30, { ancho: "medio" }),
          botonTexto: texto("Texto del botón", "", 30, { ancho: "medio" }),
          link: link("Link", ""),
        },
        defecto: [
          { imagen: "/img/productos/vestido-margarita-2.webp", titulo: "Vestidos", botonTexto: "Ver vestidos", link: "/categoria/vestidos" },
          { imagen: "/img/productos/conjunto-lima-1.jpg", titulo: "Ropa", botonTexto: "Ver ropa", link: "/categoria/ropa" },
        ],
      },
    },
  },

  masVendidos: {
    titulo: "Más productos",
    descripcion: "Segunda grilla de productos, debajo de las fotos destacadas.",
    campos: {
      titulo: tituloSeccion("Te va a encantar"),
      cantidad: { tipo: "numero", etiqueta: "Cuántos mostrar", defecto: 4, max: 12, ancho: "medio" },
      linkTexto: texto("Texto del link", "Ver todo", 30, { ancho: "medio" }),
      linkUrl: link("A dónde lleva", "/buscar"),
    },
  },

  beneficios: {
    titulo: "Beneficios",
    descripcion: "Cuatro avisos cortos de envío, pago y cambios.",
    campos: {
      items: {
        tipo: "lista",
        etiqueta: "Avisos",
        item: "Aviso",
        cantidad: 4,
        campos: {
          titulo: texto("Título", "", 36),
          texto: parrafo("Texto", "", 110),
        },
        defecto: [
          { titulo: "Envíos a todo el país", texto: "Gratis en compras superiores a $60.000." },
          { titulo: "10% off", texto: "Pagando por transferencia bancaria." },
          { titulo: "Hasta 6 cuotas", texto: "Con tarjeta de crédito, por Mercado Pago." },
          { titulo: "Cambios fáciles", texto: "Si no te queda, lo cambiamos sin vueltas." },
        ],
      },
    },
  },
};

// El local va al final del inicio, después de los beneficios
SECCIONES.local = {
  titulo: "Nuestro local",
  descripcion: "La sección del final con el video del local, la dirección y el mapa.",
  campos: {
    etiqueta: etiquetaSeccion("Nuestro local"),
    titulo: tituloSeccion("Vení a *conocernos*"),
    bajada: parrafo("Texto", "Renovamos todo para vos. Pasá a probarte lo nuevo, te esperamos con mucho amor.", 200),
    direccion: texto("Dirección", "Av. Belgrano Sur 1704", 60, { ancho: "medio" }),
    referencia: texto("Referencia", "Esquina Dorrego", 60, { ancho: "medio" }),
    ciudad: texto("Ciudad", "Santiago del Estero", 60, { ancho: "medio", ayuda: "Se usa también para ubicar el mapa." }),
    horarios: texto("Horarios", "", 80, { ancho: "medio", ayuda: "Ej: Lunes a sábado · 9 a 13 y 17 a 21 hs. Vacío no se muestra." }),
    botonTexto: texto("Botón", "Cómo llegar", 30, { ancho: "medio" }),
    mapa: { tipo: "opciones", etiqueta: "Mostrar mapa", opciones: { si: "Sí", no: "No" }, defecto: "si" },
  },
};

module.exports = { SECCIONES, FONDOS, POSICIONES };
