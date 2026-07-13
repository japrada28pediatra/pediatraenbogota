# Registro de cambios SEO

Este documento conserva las decisiones, cambios, validaciones, riesgos y datos pendientes del trabajo SEO. Debe actualizarse después de cada lote.

Documento rector: [`PLAN_SEO_SALITRE.md`](PLAN_SEO_SALITRE.md)

## Reglas del registro

- Una entrada por lote, con fecha y archivos afectados.
- Distinguir entre cambio preparado localmente y cambio verificado en producción.
- No marcar una tarea como completada solo porque un archivo fue creado: deben pasar sus validaciones.
- Registrar cualquier dato comercial o médico que necesite confirmación del usuario.
- No eliminar entradas anteriores; si una decisión cambia, añadir una nueva entrada explicando el motivo.

## Línea base

Fecha: 2026-07-12

### Datos disponibles

- Exportaciones de Search Console en `analisis/`.
- Período configurado: últimos 12 meses.
- Serie diaria disponible: 2025-12-06 a 2026-07-10.
- 517 clics, 12.436 impresiones y CTR agregado aproximado de 4,16%.
- Foco comercial confirmado por el usuario: atención cerca de Ciudad Salitre.

### Condiciones confirmadas

- Se conservarán todas las páginas útiles.
- Las páginas similares se diferenciarán; no se fusionarán por conveniencia.
- Las redirecciones solo consolidarán variantes técnicas de la misma página.
- Los cambios se implementarán por lotes pequeños y verificables.

### Estado técnico inicial

- 831 páginas públicas de contenido inventariadas.
- `robots.txt` inexistente.
- 37 archivos de sitemap: 1 sitemap del root, 1 índice llamado `sitemap3.xml` y 35 sitemaps temáticos.
- `sitemap3.xml` referencia correctamente los 35 sitemaps temáticos, pero no el sitemap del root.
- 757 entradas de sitemap todavía usan `.html` y requieren un lote posterior.
- 37 canonical necesitan corrección.
- 288 enlaces internos todavía apuntan a variantes sin `/`.
- 108 páginas requieren revisión por posible ausencia de enlaces entrantes.

## Historial de lotes

## 2026-07-12 — Documentación y planificación

Estado: completado localmente.

Archivos:

- `PLAN_SEO_SALITRE.md`
- `REGISTRO_CAMBIOS_SEO.md`

Cambios:

- Se creó el plan maestro por fases.
- Se definieron las reglas de conservación de páginas.
- Se asignó una intención preliminar diferente a las tres páginas principales de Salitre.
- Se creó este registro permanente.

Validación:

- El plan fue revisado contra la auditoría local y Search Console.
- No se modificó contenido público durante la planificación.

## 2026-07-12 — Fase 0: auditoría reproducible

Estado: completado y validado localmente.

Objetivo:

- disponer de una medición repetible antes y después de cada lote;
- detectar pérdida de páginas, canonical inconsistentes, metadata incompleta y enlaces no canónicos.

Archivo:

- `scripts/seo_audit.rb`

Resultado de la línea base:

- 831 páginas públicas;
- 37 canonical inconsistentes;
- 8 páginas sin `og:url`;
- 2.421 bloques de datos estructurados;
- 61 imágenes sin `alt`;
- 288 enlaces internos no canónicos en 18 destinos;
- 20 rutas internas no resueltas;
- 108 páginas potencialmente huérfanas.

Validación:

- el script produjo JSON válido;
- el inventario coincide con la auditoría manual previa;
- no escribe ni modifica archivos públicos.

## 2026-07-12 — Lote 1.1/1.2: rastreo e índice de sitemaps

Estado: completado y validado localmente; pendiente despliegue y comprobación HTTP en producción.

Archivos previstos:

- `robots.txt`
- `sitemap-index.xml`

Alcance:

- permitir rastreo del contenido público;
- declarar un sitemap índice estable;
- incluir el sitemap del root y los 35 sitemaps temáticos.

Resultado:

- `robots.txt` permite el rastreo general y declara `sitemap-index.xml`;
- `sitemap-index.xml` contiene 36 referencias únicas;
- las 36 referencias corresponden a archivos locales existentes;
- el XML supera validación con `xmllint`;
- no se añadieron reglas que bloqueen CSS, JavaScript o imágenes.

Fuera de alcance de este lote:

- corregir las 757 URLs `.html` dentro de los sitemaps;
- modificar canonical;
- editar contenido Salitre.

## Datos pendientes de confirmar

Antes de reescribir páginas de Salitre se necesita confirmar:

- referencia geográfica o ubicación real que se puede publicar;
- modalidad presencial disponible y lugar donde se presta;
- cobertura domiciliaria real alrededor de Salitre;
- forma correcta de comunicar horarios y disponibilidad;
- servicios efectivamente ofrecidos;
- si se publicarán tarifas;
- credenciales profesionales que pueden mostrarse;
- testimonios reales autorizados, si existen.

## Próximo lote previsto

1. Ejecutar y validar la auditoría reproducible.
2. Desplegar `robots.txt` y `sitemap-index.xml`.
3. Verificar respuesta HTTP `200` y tipos de contenido en producción.
4. Comenzar el lote 1.3 para normalizar las URLs de los sitemaps, sin tocar contenido.

## 2026-07-12 — Lote 1.3: normalización de sitemaps

Estado: completado y validado localmente; pendiente comprobación HTTP en producción.

Resultado:

- 757 URLs `.html` migradas a su variante terminada en `/`;
- 823 URLs de página únicas en los sitemaps;
- 0 duplicados después de normalizar;
- 0 destinos locales inexistentes;
- 37 archivos XML válidos con `xmllint`.

## 2026-07-12 — Lotes 1.4/1.5: canonical, Open Graph y enlaces

Estado: completado y validado localmente.

Archivos de soporte:

- `scripts/normalize_html_urls.rb`

Resultado:

- 37 canonical corregidas;
- 30 `og:url` corregidas y 8 añadidas;
- canonical inconsistentes: 37 → 0;
- páginas sin `og:url`: 8 → 0;
- enlaces internos no canónicos: 288 → 0;
- enlaces internos hacia `.html`: 0;
- rutas internas no resueltas después de limpiar la 404: 0.

## 2026-07-12 — Página 404 y residuos de plantilla

Estado: completado localmente; revisión visual pendiente.

Resultado:

- `lang="es"`;
- `noindex, follow`;
- title, description, Open Graph y Twitter en español;
- enlaces de navegación reemplazados por páginas reales;
- referencias públicas `ClinicMaster` y `DexignZone`: 0;
- se mantiene pendiente comprobar en producción que URLs inexistentes respondan HTTP 404.

## 2026-07-12 — Clúster Salitre, primera diferenciación

Estado: primera iteración completada; contenido profundo y revisión visual pendientes.

Resultado:

- `/pediatra-ciudad-salitre/`: intención principal “pediatra cerca de Ciudad Salitre”;
- `/pediatra-domicilio-bogota/pediatra-domicilio-salitre/`: intención exclusiva de consulta en casa;
- `/pediatra-zonas-bogota/pediatra-salitre/`: intención de guía territorial y modalidades;
- titles, H1, descriptions, Open Graph y MedicalWebPage diferenciados;
- enlaces cruzados directos entre las tres páginas;
- home enlaza la landing local principal;
- hub de domicilio enlaza la landing domiciliaria de Salitre.

No se modificaron afirmaciones que requieren confirmación del usuario, como dirección exacta, horarios, tarifas o límites de cobertura.

## 2026-07-12 — Medición, imágenes y enlaces comerciales

Estado: lote técnico completado localmente.

Archivos de soporte:

- `scripts/consolidate_google_tags.rb`

Resultado:

- 810 páginas con dos loaders `gtag.js` consolidadas;
- las 831 páginas públicas conservan exactamente una configuración GA4;
- Ads se conserva en las 822 páginas donde ya estaba configurado;
- Google Tag Manager se conserva sin alterar su contenedor;
- imágenes sin `alt`: 61 → 0;
- enlaces a agencias digitales calificados con `rel="sponsored noopener noreferrer"`;
- enlaces comerciales sin `sponsored`: 0.
- 792 footers conservan la frase de crédito enlazada solicitada;
- enlaces duplicados a esas agencias dentro del bloque “Sitios”: 0.

Pendiente:

- validar en navegador que GA4 no genere pageviews duplicados por configuración interna del contenedor GTM;
- revisar las 167 imágenes con `alt` vacío;
- añadir dimensiones y optimizar imágenes pesadas;
- revisión visual en navegador de las páginas modificadas.

## 2026-07-12 — Enlazado de páginas huérfanas

Estado: completado y validado estructuralmente; revisión visual pendiente.

Archivo de soporte:

- `scripts/link_orphan_pages.rb`

Resultado:

- páginas potencialmente huérfanas: 108 → 1;
- 92 páginas enlazadas desde 31 índices de su propia categoría;
- landings geográficas del root enlazadas desde `/zonas-de-atencion-bogota/`;
- teleconsulta y páginas de citas enlazadas desde el home;
- la única página sin enlaces entrantes es `/error-404/`, lo cual es intencional por estar `noindex`;
- enlaces internos rotos: 0.

## 2026-07-12 — Revisión de textos alternativos

Estado: primera revisión completada.

Resultado:

- imágenes sin atributo `alt`: 61 → 0;
- se añadieron textos descriptivos a logos, credenciales institucionales, fotografía profesional y gráficos de agendamiento;
- imágenes con `alt` vacío: 167 → 111;
- las 111 restantes corresponden a elementos decorativos o imágenes genéricas cuya descripción no aporta información fiable;
- se corrigieron rutas de logos y fondo heredadas de `../src/` en la página 404.

Pendiente:

- comprobar visualmente la página 404 y las páginas antiguas de citas;
- definir dimensiones intrínsecas y formatos optimizados sin afectar el layout.
