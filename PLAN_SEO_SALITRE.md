# Plan maestro SEO — Pediatra en Bogotá

Fecha de preparación: 2026-07-12  
Foco comercial principal: Ciudad Salitre y sectores cercanos  
Fuente de datos: auditoría técnica local y exportaciones de Google Search Console de `analisis/`

## 1. Objetivo

Mejorar el rendimiento orgánico y la conversión del sitio sin eliminar ninguna página útil, preservando el historial acumulado y diferenciando correctamente las páginas que actualmente comparten temas o intenciones de búsqueda.

El proyecto se ejecutará por lotes pequeños. Cada lote debe superar sus validaciones antes de comenzar el siguiente.

## 2. Reglas no negociables

- No eliminar páginas existentes.
- No reemplazar una página útil por otra diferente.
- No crear redirecciones entre páginas distintas solo para reducir el número de URLs.
- Conservar indefinidamente las redirecciones técnicas desde `.html` y desde la versión sin `/` hacia la URL canónica de esa misma página.
- No inventar dirección, consultorio, horario, disponibilidad, precio, cobertura, credenciales, testimonios ni datos médicos.
- No afirmar que el consultorio está en Ciudad Salitre si la ubicación real solo está cerca de Salitre.
- No repetir contenido de manera mecánica entre landings.
- No modificar cientos de páginas sin probar primero el cambio sobre una muestra pequeña.
- No mezclar correcciones técnicas, reescritura de contenido y cambios de diseño en un mismo lote.
- Preservar los cambios del usuario y revisar el estado de Git antes de cada lote.

## 3. Estado base conocido

### Search Console

- Período exportado: últimos 12 meses.
- Serie diaria disponible: 2025-12-06 a 2026-07-10.
- 517 clics y 12.436 impresiones en la serie diaria.
- Junio de 2026 fue el mejor mes completo: 152 clics y 2.944 impresiones.
- 35 grupos de páginas aparecen históricamente bajo más de una variante de URL.
- La oportunidad principal es `pediatra a domicilio`: 3.602 impresiones consolidadas en la landing histórica y CTR de 1,30%.
- Soacha, Kennedy y Facatativá/Madrid son las landings geográficas con mayor tracción demostrada.
- El clúster online/virtual tiene impresiones, pero muy pocos clics.

### Auditoría técnica

- 831 páginas públicas de contenido, excluyendo plantillas, demos y verificación de Google.
- No existe `robots.txt` en producción.
- Hay 37 archivos de sitemap y el sitemap principal no funciona como índice completo.
- 757 entradas de sitemap todavía usan `.html`.
- 37 canonical no coinciden con la URL canónica esperada.
- 288 enlaces internos apuntan a variantes sin `/`.
- 108 páginas aparecen potencialmente huérfanas.
- Hay 20 destinos internos dudosos o heredados de plantilla.
- Los 2.421 bloques JSON-LD revisados son JSON válido.
- Hay 61 imágenes sin atributo `alt`, 167 con `alt` vacío y ninguna con dimensiones HTML explícitas detectadas.

## 4. Arquitectura objetivo del clúster Salitre

Todas las páginas se conservan, pero cada una debe responder a una intención distinta.

| Página | Función principal | Intención prioritaria | No debe competir principalmente por |
|---|---|---|---|
| `/pediatra-ciudad-salitre/` | Landing local principal | pediatra cerca de Ciudad Salitre, consulta pediátrica cerca de Salitre | pediatra exclusivamente a domicilio |
| `/pediatra-domicilio-bogota/pediatra-domicilio-salitre/` | Landing domiciliaria local | pediatra a domicilio en Salitre, consulta pediátrica en casa | consulta pediátrica general cerca de Salitre |
| `/pediatra-zonas-bogota/pediatra-salitre/` | Guía territorial y de modalidades | zonas y modalidades de atención pediátrica en Salitre | ser la landing transaccional principal |
| `/zonas-de-atencion-bogota/` | Hub geográfico | zonas de atención pediátrica en Bogotá | una sola zona o modalidad |
| `/pediatra-a-domicilio-bogota/` | Hub del servicio domiciliario | pediatra a domicilio en Bogotá | una sola localidad |
| `/` | Marca y oferta general | pediatra en Bogotá y modalidades de atención | dominar todas las búsquedas específicas de Salitre |

Antes de redactar contenido debe confirmarse con el usuario:

- ubicación real o referencia geográfica que se puede publicar;
- si hay consulta presencial y dónde se presta;
- cobertura domiciliaria real alrededor de Salitre;
- horarios o forma correcta de expresar disponibilidad;
- servicios que efectivamente se pueden ofrecer;
- información verificable de tarifas, si se desea publicarla.

## 5. Orden de ejecución

## Fase 0 — Línea base y controles

Objetivo: poder medir cada cambio y evitar modificaciones accidentales.

- [ ] Registrar `git status` y conservar cambios preexistentes.
- [ ] Generar inventario de páginas públicas y sus URLs canónicas esperadas.
- [ ] Generar reporte reproducible de title, description, H1, canonical, `og:url`, schemas y enlaces.
- [ ] Guardar lista de URLs con impresiones/clics de Search Console.
- [ ] Definir una muestra de prueba: home, Ciudad Salitre, domicilio Salitre, guía Salitre y una página no relacionada.
- [ ] Documentar comandos de validación antes de editar.

Validación de salida:

- inventario reproducible;
- ninguna página modificada;
- lista de control disponible para comparar antes y después.

## Fase 1 — Canonicalización, rastreo y sitemaps

Objetivo: consolidar señales sin cambiar el contenido ni perder páginas.

### Lote 1.1 — `robots.txt`

- [ ] Crear `robots.txt` permitiendo el rastreo del contenido público.
- [ ] Declarar un único sitemap índice.
- [ ] No bloquear CSS, JavaScript ni imágenes necesarias para renderizar.
- [ ] Validar respuesta `200` y tipo de contenido.

### Lote 1.2 — Sitemap índice

- [ ] Crear `sitemap-index.xml` en el root.
- [ ] Referenciar únicamente sitemaps existentes y válidos.
- [ ] Mantener sitemaps temáticos para facilitar el seguimiento en Search Console.
- [ ] No incluir demos, plantillas, AJAX, página 404 ni archivo de verificación.

### Lote 1.3 — URLs de sitemaps

- [ ] Cambiar entradas `.html` a URLs terminadas en `/`.
- [ ] Eliminar entradas duplicadas después de normalizar.
- [ ] Confirmar que cada URL responde `200` sin redirección.
- [ ] Usar `lastmod` solo cuando exista una fecha fiable.
- [ ] No depender de `priority` o `changefreq` como sustituto de una arquitectura correcta.

### Lote 1.4 — Canonical y Open Graph

- [ ] Corregir primero las 37 canonical inconsistentes.
- [ ] Hacer coincidir canonical, `og:url`, schema y URL del sitemap.
- [ ] Revisar especialmente `teleconsulta-virtual.html`, cuya canonical histórica apunta a otra página.
- [ ] Probar el lote sobre cinco páginas antes de extenderlo.

### Lote 1.5 — Enlaces internos no canónicos

- [ ] Corregir los 288 destinos internos sin `/`.
- [ ] Mantener enlaces relativos solo cuando su resolución sea inequívoca.
- [ ] Preferir rutas absolutas desde el root para enlaces entre subcarpetas.
- [ ] Verificar que ningún enlace interno termine en `.html`.

### Lote 1.6 — Páginas especiales

- [ ] Añadir `noindex, follow` a `/error-404/` cuando se visita directamente.
- [ ] Mantener respuesta HTTP `404` para URLs inexistentes.
- [ ] Revisar y retirar enlaces a rutas de plantilla inexistentes, sin borrar páginas reales.

Validación de la fase:

- 0 canonical inconsistentes;
- 0 URLs `.html` en sitemaps, enlaces internos, metadata o schemas;
- 0 URLs de sitemap que redirijan;
- `robots.txt` y sitemap índice con respuesta `200`;
- todas las páginas existentes siguen disponibles;
- redirecciones antiguas continúan funcionando con `301`.

## Fase 2 — Optimización de Ciudad Salitre

Objetivo: construir el activo local principal sin canibalizar otras páginas.

### Lote 2.1 — Matriz de intención y contenido existente

- [ ] Comparar title, H1, secciones, FAQs, schemas y enlaces de las tres páginas Salitre.
- [ ] Marcar contenido repetido o intercambiable.
- [ ] Asignar consulta principal, consultas secundarias y CTA a cada página.
- [ ] Definir qué información debe vivir solo en una página y cuál puede resumirse con enlace.

### Lote 2.2 — `/pediatra-ciudad-salitre/`

- [ ] Reescribir title, description, H1 e introducción con enfoque local principal.
- [ ] Explicar la relación real con Ciudad Salitre sin afirmar una dirección falsa.
- [ ] Describir modalidades disponibles y pacientes atendidos.
- [ ] Añadir motivos frecuentes de consulta con lenguaje prudente.
- [ ] Añadir sección clara de agendamiento.
- [ ] Incorporar preguntas frecuentes locales no duplicadas.
- [ ] Añadir enlaces contextuales a domicilio Salitre, citas, virtual y zonas.
- [ ] Revisar Physician/MedicalWebPage/BreadcrumbList según corresponda.

### Lote 2.3 — Domicilio Salitre

- [ ] Limitar la intención principal a atención en casa.
- [ ] Explicar cómo se confirma cobertura y disponibilidad.
- [ ] Diferenciar consulta domiciliaria, virtual, presencial y urgencias.
- [ ] Evitar promesas de atención inmediata o 24/7 no verificadas.
- [ ] Enlazar a Ciudad Salitre y al hub de domicilio Bogotá.

### Lote 2.4 — Guía territorial Salitre

- [ ] Convertirla en guía de zona y modalidades.
- [ ] Evitar repetir la propuesta comercial completa de la landing principal.
- [ ] Distribuir autoridad hacia Ciudad Salitre, domicilio y citas.
- [ ] Mantener contenido útil suficiente para conservar valor propio.

### Lote 2.5 — Home y hubs

- [ ] Añadir una sección comercial honesta sobre atención cerca de Salitre.
- [ ] Enlazar Ciudad Salitre desde home y `/zonas-de-atencion-bogota/`.
- [ ] Enlazar domicilio Salitre desde `/pediatra-a-domicilio-bogota/`.
- [ ] Evitar sobreoptimizar el title del home con listas de barrios.

Validación de la fase:

- cada página tiene intención, title, H1 y description diferenciados;
- ninguna afirma datos no confirmados;
- todas se enlazan de forma lógica;
- no hay contenido sustancialmente duplicado;
- no se perdió ninguna URL.

## Fase 3 — Conversión y medición de Salitre

- [ ] Definir CTA principal por página.
- [ ] Crear mensajes de WhatsApp específicos sin prometer disponibilidad no confirmada.
- [ ] Medir clics en WhatsApp, teléfono y formularios con GA4.
- [ ] Registrar página de origen y modalidad solicitada.
- [ ] Verificar que Analytics no se cargue dos veces.
- [ ] Probar eventos en móvil y escritorio.
- [ ] Establecer reporte mensual para impresiones, clics, CTR, posición y conversiones del clúster.

## Fase 4 — Enlazado interno temático

Objetivo: reducir páginas huérfanas y distribuir autoridad con contexto.

- [ ] Revisar manualmente las 108 páginas potencialmente huérfanas.
- [ ] Priorizar páginas con impresiones en Search Console.
- [ ] Conectar Salitre con zonas cercanas solo cuando sea útil para el usuario.
- [ ] Conectar contenidos médicos con la modalidad de consulta pertinente.
- [ ] Añadir de 3 a 5 enlaces contextuales útiles por página, no una cuota mecánica.
- [ ] Usar anchors descriptivos, variados y naturales.
- [ ] Evitar bloques masivos de enlaces repetidos en todos los footers.
- [ ] Implementar breadcrumbs consistentes donde falten.

Validación:

- 0 páginas prioritarias huérfanas;
- enlaces rastreables con `<a href>`;
- 0 destinos rotos;
- crecimiento medible de conexiones entre subcarpetas.

## Fase 5 — Diferenciación del resto del proyecto

Aplicar el modelo aprendido en Salitre, una categoría por vez:

1. domicilio Bogotá;
2. online/virtual;
3. zonas con rendimiento histórico: Soacha, Kennedy, Facatativá/Madrid y Fontibón;
4. recién nacido, fiebre y señales de alarma;
5. categorías restantes.

Para cada página:

- [ ] intención principal única;
- [ ] intención secundaria compatible;
- [ ] title, H1 y description propios;
- [ ] CTA acorde con la intención;
- [ ] contenido útil y no intercambiable;
- [ ] enlaces hacia su hub y páginas complementarias;
- [ ] schema coherente con el contenido visible.

No se fusionarán páginas. Cuando exista solapamiento, se diferenciarán por intención, profundidad, audiencia, modalidad o ubicación.

## Fase 6 — Confianza médica y SEO local

- [ ] Añadir fechas visibles y verificables de publicación/actualización.
- [ ] Incorporar `datePublished` y `dateModified` donde correspondan.
- [ ] Reforzar la página profesional de la Dra. Jazmín Prada.
- [ ] Mostrar autoría y revisión médica de forma visible.
- [ ] Añadir fuentes médicas confiables a contenidos clínicos prioritarios.
- [ ] Revisar consistencia de nombre, teléfono y ubicación publicable.
- [ ] Usar `areaServed` y `availableService` solo con datos reales.
- [ ] Coordinar la landing de Salitre con el perfil de Google Business, si existe y corresponde.

## Fase 7 — Calidad on-page y enlaces externos

- [ ] Revisar los 103 titles extensos de forma editorial, sin recortarlos automáticamente.
- [ ] Ampliar las 37 descriptions demasiado breves cuando no comuniquen bien la propuesta.
- [ ] Revisar las 30 descriptions extensas y priorizar claridad sobre una longitud mecánica.
- [ ] Corregir titles, descriptions o H1 duplicados conservando la intención de cada página.
- [ ] Completar `og:title`, `og:description`, `og:url` y `og:image` donde falten.
- [ ] Confirmar que los créditos de desarrollo no se dupliquen dentro del mismo footer.
- [ ] Calificar enlaces comerciales o patrocinados con `rel="sponsored noopener noreferrer"` cuando corresponda.
- [ ] Mantener enlaces externos editoriales normales cuando sean fuentes médicas confiables.
- [ ] Revisar que ningún enlace externo heredado de plantilla permanezca publicado.

## Fase 8 — Imágenes y rendimiento

- [ ] Corregir primero las 61 imágenes sin `alt`.
- [ ] Revisar manualmente las 167 imágenes con `alt` vacío.
- [ ] Añadir dimensiones para reducir CLS.
- [ ] Convertir banners PNG pesados a WebP/AVIF conservando originales hasta validar calidad.
- [ ] No aplicar lazy loading a la imagen LCP.
- [ ] Mantener lazy loading en imágenes fuera del primer viewport.
- [ ] Medir antes y después con Lighthouse/PageSpeed en móvil.

## Fase 9 — Seguimiento en Search Console

- [ ] Enviar el sitemap índice corregido.
- [ ] Inspeccionar home y las tres páginas Salitre.
- [ ] Comparar ventanas de 28 días sin mezclar períodos parciales.
- [ ] Monitorear consultas por página para detectar canibalización real.
- [ ] Mantener un registro de cambios con fecha, URL y objetivo.
- [ ] No revertir una mejora por fluctuaciones de pocos días.

Datos adicionales necesarios para una segunda capa de análisis:

- consulta + página;
- consulta + fecha;
- página + dispositivo;
- comparación con período anterior;
- indexación, Core Web Vitals y enlaces de Search Console;
- conversiones de GA4 por landing.

## 6. Protocolo para cada lote

1. Registrar estado inicial y archivos que se tocarán.
2. Revisar contenido y dependencias de esas páginas.
3. Escribir el cambio mínimo necesario.
4. Ejecutar validaciones automáticas.
5. Revisar visualmente una muestra en navegador.
6. Comparar metadata, enlaces y schema antes/después.
7. Informar al usuario exactamente qué cambió.
8. Esperar aprobación antes de iniciar un lote que cambie intención, información comercial o datos locales.

## 7. Criterios globales de finalización

- Ninguna página útil fue eliminada.
- Todas las URLs históricas equivalentes redirigen a su misma página canónica.
- Sitemap, canonical, Open Graph, schema y enlaces internos usan la misma URL.
- Las páginas Salitre tienen intenciones claramente distintas.
- No existen afirmaciones comerciales o médicas no verificadas.
- Las páginas prioritarias reciben enlaces internos contextuales.
- Analytics mide las acciones comerciales sin duplicar pageviews.
- Los cambios quedan documentados y pueden auditarse.

## 8. Primer lote propuesto

El primer lote de implementación será **Fase 0 — Línea base y controles**. No cambiará contenido público. Producirá el inventario reproducible y las pruebas que se usarán para validar todos los lotes posteriores.

Después de revisar sus resultados, se continuará con **Lote 1.1 — `robots.txt`** y **Lote 1.2 — sitemap índice**, cada uno por separado.
