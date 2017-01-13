<a name="title"></a>
# WebAssembly

<a name="intro"></a>
## Въведение

***WebAssembly***, или *wasm*, е платформа (включваща в себе си *виртуална машина*) за компилация и изпълнение на клиентски (т.е. браузър-базирани) уеб приложения.<sup>[[NUMBER]](#ref-website-wasm)</sup>

<a name="features"></a>
## Предимства

*WebAssembly* има следните основни предимства:
* преносим е (изпълнява се на множество различни хардуерни платформи, операционни системи, браузъри и т.н.);
* оптимизиран е откъм размер на генерираните изпълними файлове и откъм тяхното време на зареждане и изпълнение;
* отворен стандарт е на *W3C* общността, която включва представители на всички най-използвани браузъри.<sup>[[NUMBER]](#ref-website-wasm-cg)</sup>

<a name="features-fast"></a>
### *WebAssembly* е ефективен и бърз

Платформата *WebAssembly* е базирана на *стекова виртуална машина*<sup>[[NUMBER]](#ref-wp-stack-machine)</sup>.  Нейният [байткод](#semantics) използва [бинарен формат за изпълними файлове](#binary-encoding), който е оптимизиран откъм размер и време за изпълнение.
*WebAssembly* се стреми да постигне скорост на изпълнение, сходна с тази на софтуера, изпълняван директно (*native*) върху реалния хардуер на машината.  За да постигне тази цел по ефективен начин, той се възползва от множеството способности за оптимизация, вградени в хардуера на многото поддържани от него платформи.

<a name="features-safe"></a>
### *WebAssembly* е безопасен

*WebAssembly* включва в себе си изолирана среда за изпълнение (*sandboxed execution environment*<sup>[[NUMBER]](#ref-wp-sandbox)</sup>), която гарантира безопасността на достъпа до паметта.  При вграждане в уеб страници *WebAssembly* гарантира следването на *same-origin*<sup>[[NUMBER]](#ref-wp-same-origin)</sup> правилото и политиките за сигурност на браузъра, в който се изпълнява.

### *WebAssembly* е отворен и подходящ за дебъгване
<a name="features-open"></a>

*WebAssembly* е направен да може да се извежда (*pretty-print*) в текстов формат за по-лесно дебъгване, тестване, експериментиране, оптимизиране, научаване, обучение и писане на програми на ръка.  Този формат се използва при показването на изходния код на *wasm* модули в уеб браузъра.

<a name="features-web"></a>
### *WebAssembly* е част от общата уеб платформа

*WebAssembly* е създаден със съображението, че в уеб пространството няма версии, но за сметка на това има обратна съвместимост.  *WebAssembly* модулите могат да достъпват функционалността на браузъра през същите програмни интерфейси, които са достъпни и през JavaScript.  Освен всичко това *WebAssembly* поддържа вграждане в софтуер, който не е предназначен за уеб.


<a name="goals"></a>
## Цели на проекта *WebAssembly*

* Да дефинира бинарен формат за изпълними файлове, който е оптимизиран откъм размер и време за изпълнение.  Програмите, компилирани до него, трябва да достигат скорост на изпълнение, сходна с тази на софтуера, изпълняван директно върху реалния хардуер на машината.
* Да специфицира и да имплементира един по един следните стадии на развитие:
  * *минимален работещ продукт* (*minimum viable product*<sup>[[NUMBER]](#ref-wp-mvp)</sup>) с функционалност, сходна с тази на оптимизирания вариант на JavaScript `asm.js`<sup>[[NUMBER]](#ref-wp-asmjs)</sup>, която да таргетира основно езиците C и C++;
  * продукт с допълнителни характеристики, първоначално фокусирани върху ключови свойства за една виртуална машина, като например поддръжка за нишки, *zero-cost* изключения и SIMD инструкции, както и поддръжка за езици, различни от C и C++.
* Да може да се изпълнява в рамките на и да се интегрира с вече съществуващата уеб платформа:
  * да се съобразява с липсата на версии и силно изявената обратна съвместимост, утвърдили се като *де факто* стандарт при постепенното развитие на уеб технологиите;
  * да е съвместима със семантиката на езика за програмиране JavaScript;
  * да поддържа синхронни извиквания на JavaScript функции, както и да могат *WebAssembly* функции да бъдат извиквани от JavaScript;
  * да налага *same-origin* правилото като политика за сигурност в браузъра;
  * да достъпва функционалността на браузъра през същите уеб API-та, през които я достъпва и JavaScript;
  * да дефинира ръчно редактируем текстов формат, конвертируем към бинарния формат (който се използва по подразбиране), който може да се достъпи посредством **View Source** функционалността.
* Да поддържа вграждане в софтуер, който не е браузър.
* Да бъде използваема и надеждна платформа чрез създаването на:
  * *LLVM* бекенд за *WebAssembly* и, съответно, port-нат вариант на *clang* за този бекенд;
  * допълнителни компилатори и придружаващи ги инструменти, таргетиращи *WebAssembly*;
  * други полезни инструменти за *WebAssembly*.

<a name="rationale"></a>
## Причини за създаване

При положение, че вече съществуват технологии като `asm.js`, както и имплементации на POSIX нишки (*pthreads*)<sup>[[NUMBER]](#ref-paralleljs)</sup><sup>[[NUMBER]](#ref-blinkdev-shbuf)</sup> и SIMD инструкции<sup>[[NUMBER]](#ref-simdjs)</sup><sup>[[NUMBER]](#ref-blinkdev-simdjs)</sup> във Firefox и Chromium, на пръв поглед разработването на *WebAssembly* изглежда лишено от смисъл.

Разбира се, на практика нещата са доста по-различни.  *WebAssembly* има две основни предимства, които гореспоменатите технологии не предоставят:
1. Бинарният формат, използван в *WebAssembly*, може да се декодира много по-бързо, отколкото JavaScript може се парсва (експерименталните данни показват над 20-кратно ускорение).  На мобилните платформи големи кодови бази могат да отнемат от 20 до 40 секунди *само* за парсване (дори и да са минифицирани), така че *native* декодирането (особено когато е комбинирано с други техники като stream-ове<sup>[[NUMBER]](#ref-streams-api)</sup> за постигане на по-добра компресия от *gzip*) е ключово за постигането на добър UX при студен старт.
2. Чрез избягването на ограничението за задължителна *ahead-of-time* компилация<sup>[[NUMBER]](#ref-asmjs-aot)</sup> и постигането на добра производителност дори при енджини без специфични `asm.js` оптимизации<sup>[[NUMBER]](#ref-asmjs-opts)</sup> може [имплементацията да се разшири](#future-features) по подходящ начин, така че се достигат *native* нива на производителност.

Естествено, всеки нов стандарт създава затруднения (трябва да се поддържа и обновява; може да бъде потенциална цел за хакерски атаки; размерът на кода трябва да се придържа в разумни граници), които могат евентуално да засенчат предимствата му.  *WebAssembly* се старае да направи затрудненията минимални, използвайки дизайн, който позволява на (но не задължава) всеки един браузър да го имплементира *вътре* в собствения си JavaScript енджин, преизползвайки по този начин вече съществуващия компилиращ бекенд на енджина, както и фронтенда за зареждане на *ECMAScript* 6 (ES6) модули, механизмите за изолация (*sandboxing*) на програмите и други допълнителни компоненти на виртуалната машина.  Затова от гледна точка на трудност и цена на имплементация *WebAssembly* трябва да се разглежда по-скоро като голям нов *feature* на JavaScript, отколкото като фундаментално разширение на модела на браузъра.

Ако сравняваме *WebAssembly* и `asm.js`, даже и при енджините, при които `asm.js` вече е оптимизиран, предимствата надхвърлят недостатъците и рисковете.


## Семантика на изпълнението на байткода
<a name="semantics"></a>

## Бинарен формат за изпълнимите файлове
<a name="binary-encoding"></a>

## Редактируем текстов формат
<a name="text-format"></a>

## Преносимост
<a name="portability"></a>

## Сигурност
<a name="security"></a>

## Употреба за уеб-базирани приложения
<a name="web"></a>

## Употреба извън уеб
<a name="non-web"></a>

## Приложения
<a name="use-cases"></a>

## Какво предстои
<a name="future-features"></a>

<a name="ref"></a>
## Източници

NUMBER. <a name="ref-website-wasm"></a>Уебсайт на *WebAssembly*, http://webassembly.org/, последно посетен на 2017-01-12.
NUMBER. <a name="ref-website-wasm-cg"></a>Уебсайт на *WebAssembly Community Group*, https://www.w3.org/community/webassembly/, последно посетен на 2017-01-12.
NUMBER. <a name="ref-wp-stack-machine"></a>Wikipedia, *Stack machine*, https://en.wikipedia.org/wiki/Stack_machine, последно посетен на 2017-01-12.
NUMBER. <a name="ref-wp-sandbox"></a>Wikipedia, *Sandbox*, https://en.wikipedia.org/wiki/Sandbox_(computer_security), последно посетен на 2017-01-12.
NUMBER. <a name="ref-wp-same-origin"></a>Wikipedia, *Same-origin policy*, https://en.wikipedia.org/wiki/Same-origin_policy, последно посетен на 2017-01-12.
NUMBER. <a name="ref-wp-mvp"></a>Wikipedia, *Minimum viable product*, https://en.wikipedia.org/wiki/Minimum_viable_product, последно посетен на 2017-01-12.
NUMBER. <a name="ref-wp-asmjs"></a>Wikipedia, *`asm.js`*, https://en.wikipedia.org/wiki/Asm.js, последно посетен на 2017-01-12.
NUMBER. <a name="ref-paralleljs"></a>Mozilla JavaScript Blog, *The Path to Parallel JavaScript*, https://blog.mozilla.org/javascript/2015/02/26/the-path-to-parallel-javascript/, последно посетен на 2017-01-12.
NUMBER. <a name="ref-blinkdev-shbuf"></a>*blink-dev* forum of the `chromium.org` Google Group, *Intent to Implement: Shared Array Buffers*, https://groups.google.com/a/chromium.org/forum/#!topic/blink-dev/d-0ibJwCS24, последно посетен на 2017-01-12.
NUMBER. <a name="ref-simdjs"></a>Mozilla Hacks - the Web developer blog, *Introducing SIMD.js*, https://hacks.mozilla.org/2014/10/introducing-simd-js/, последно посетен на 2017-01-12.
NUMBER. <a name="ref-blinkdev-simdjs"></a>*blink-dev* forum of the `chromium.org` Google Group, *Intent to Implement: SIMD.js*, https://groups.google.com/a/chromium.org/forum/#!topic/blink-dev/2PIOEJG_aYY, последно посетен на 2017-01-12.
NUMBER. <a name="ref-streams-api"></a>*W3C* Working Group Note, *Streams API*, https://www.w3.org/TR/streams-api/, последно посетен на 2017-01-12.
NUMBER. <a name="ref-asmjs-aot"></a>Luke Wagner's blog, *asm.js AOT compilation and startup performance*, https://blog.mozilla.org/luke/2014/01/14/asm-js-aot-compilation-and-startup-performance/, последно посетен на 2017-01-12.
NUMBER. <a name="ref-asmjs-opts"></a>Luke Wagner's blog, *Microsoft announces `asm.js` optimizations*, https://blog.mozilla.org/luke/2015/02/18/microsoft-announces-asm-js-optimizations/#asmjs-opts, последно посетен на 2017-01-12.