'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "e360d21828d00891c7bfa403bf2ed325",
"assets/AssetManifest.bin.json": "e0761b84c6b704904b7d06cc86a4aaea",
"assets/AssetManifest.json": "67b21ecb2288058ccca05b06ae1b2cf2",
"assets/assets/audios/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/assets/fonts/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/assets/fonts/Inter-Black.ttf": "118c5868c7cc1370fcf5a1fc2f569883",
"assets/assets/fonts/Inter-Bold.ttf": "ba74cc325d5f67d0efbeda51616352db",
"assets/assets/fonts/Inter-Light.ttf": "a3fe4e0f9fdf3119c62a34b1937640dd",
"assets/assets/fonts/Inter-Medium.ttf": "cad1054327a25f42f2447d1829596bfe",
"assets/assets/fonts/Inter-Regular.ttf": "ea5879884a95551632e9eb1bba5b2128",
"assets/assets/fonts/Inter-SemiBold.ttf": "465266b2b986e33ef7e395f4df87b300",
"assets/assets/images/adaptive_foreground_icon.png": "990395737486e52912bf381eaf1bb397",
"assets/assets/images/alert-circle.svg": "376472b21eec469f47d08b05bf2d6830",
"assets/assets/images/apple.svg": "e2b7ffbde5ff01ffe92c4489f045ee34",
"assets/assets/images/applepay.svg": "6075c430a1a423708e5f3e358e69b1a5",
"assets/assets/images/app_launcher_icon.png": "990395737486e52912bf381eaf1bb397",
"assets/assets/images/ArrowDown.svg": "8189eea9ca20a65bacae286d734ff568",
"assets/assets/images/ArrowLeft.svg": "961315dc386ae1222bc095990b3c9f7b",
"assets/assets/images/attach.svg": "e4e2d5ca658bd1c33e4e0251d637c27b",
"assets/assets/images/ban.png": "baca75c7e23132138217623781e214bd",
"assets/assets/images/calendar.svg": "f91a34c39d189509266f5e1580f893cf",
"assets/assets/images/car-fill.svg": "1f4181b4c4c324dcf39315902788cd27",
"assets/assets/images/car.svg": "3656ac397cd1d234f8c3d3d6609dafdb",
"assets/assets/images/carrier.png": "5f0db6932d003cff2ee654e5d1279798",
"assets/assets/images/chat_tab.svg": "7ac33424f29e4422ae09ce8bd79dbc9e",
"assets/assets/images/clocl.svg": "0a54df06744638d10adcd30822ea14e6",
"assets/assets/images/credit_card.svg": "762f9f597d8ee35a825de93d9eb8d0c4",
"assets/assets/images/deal_tab.svg": "dac654c6476674b9cffb91f83f60f1fc",
"assets/assets/images/Delete.svg": "0e6054983bc12fad476da5a9403c0cef",
"assets/assets/images/diler.png": "92e5a0ca254cc204172539b473ab320d",
"assets/assets/images/edit.svg": "e46655de88d65be5fb3cb3d1b910bbc1",
"assets/assets/images/error_image.png": "87ec0363e468d56f6551b510474f4af1",
"assets/assets/images/facebook.svg": "5439225f5110684d25b68bbb1dc3c1e7",
"assets/assets/images/failed.png": "87ec0363e468d56f6551b510474f4af1",
"assets/assets/images/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/assets/images/file.svg": "27d9bb3de6a3eaf985e1be7a911f379d",
"assets/assets/images/Filter.svg": "b2ba0fae825dae5059c00d6f295f01ee",
"assets/assets/images/google-pay.svg": "1f9182b71ccd2477b7287d572a1bff83",
"assets/assets/images/google.svg": "4a3499585dff1359fa10531712d57e87",
"assets/assets/images/gps.svg": "a2ec97950fbfd9fabc68404bec7b2816",
"assets/assets/images/ic_current.svg": "8207489b14af6444b08edc305f8d2044",
"assets/assets/images/license.svg": "a8ea4ff7724aa48944e4abf4a69bfda0",
"assets/assets/images/list.svg": "6c5bd54b8e198c0fe1f07011e8b64e82",
"assets/assets/images/location-pin.svg": "3326f549fff9b3decea2dfdfd7fb522e",
"assets/assets/images/Location.svg": "fea86f072dc3c19b47ddb87dae845316",
"assets/assets/images/Location_fill.svg": "f9498d1d3d41cf7eb6e8bb0e2295fbb7",
"assets/assets/images/logo.png": "990395737486e52912bf381eaf1bb397",
"assets/assets/images/logo.svg": "608cc3ea11407612d3433e8d9585bf3b",
"assets/assets/images/mail.svg": "ecf43cc0fbf43f724bf17b8b3bb71fb4",
"assets/assets/images/main_tab.svg": "32f199ba688fbdb051ceec3f189e19e9",
"assets/assets/images/map.svg": "1a2f1a022e4e94fe2b7a88633f9612d6",
"assets/assets/images/mi_notification.svg": "bf6d37cd941aae502bbdefada6d58a8b",
"assets/assets/images/money-bag.svg": "09099e7e96b40f697cf3bed5fd97e324",
"assets/assets/images/new-file.svg": "5af79f200ad8e3a1b15127db826b95b0",
"assets/assets/images/no_deals.png": "800bd631b534b38a2716b676c8c223ed",
"assets/assets/images/no_deals2.png": "383bff9541e540276d58c268e038f43d",
"assets/assets/images/no_messages.png": "5de54247f5f77cb64b49b47c226e6eb9",
"assets/assets/images/no_notifications.png": "7ccf024cbfbee23b9351eca7b565161a",
"assets/assets/images/onboard1.png": "de09e6dabc92cf1a05aa17328952c196",
"assets/assets/images/onboard2.png": "1a1fa526e9d76e43c5e775eccbfe02b0",
"assets/assets/images/onboard3.png": "c6c16bd57b3d8ebe2b752347ef7c7af5",
"assets/assets/images/onboard4.png": "d39c8e3f78a644e06231cb052b8f26c0",
"assets/assets/images/paper.svg": "a6d810fd1c325bb71e8e5f2089f4e074",
"assets/assets/images/person.svg": "c9e30ccdc0b54c208834777ba32df018",
"assets/assets/images/pin.png": "77729fcbdcd5708ac187e78175fadb8b",
"assets/assets/images/profile_tab.svg": "d6e62e5cc84c668d591b0b5e54daaf36",
"assets/assets/images/responses.svg": "081333cb07343b688d5365d30e9fab4f",
"assets/assets/images/success.svg": "cf8ae7bf86353ce093e85afd386fbac1",
"assets/assets/images/support.svg": "f86562e7b5901ab6f0dd71acd7f54181",
"assets/assets/images/upload.svg": "a35992bddc6a9ea5f2e744bc925556a1",
"assets/assets/images/wallet-credit-card.svg": "b6f3480b1b3e5f5206ee52b169026f10",
"assets/assets/images/wallet.svg": "4f6c9da52d60e9a847382129be3bc744",
"assets/assets/lottie_animations/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/assets/pdfs/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/assets/rive_animations/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/assets/videos/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/FontManifest.json": "cfe657f9d8c661361684e984fe768606",
"assets/fonts/MaterialIcons-Regular.otf": "190f6421f3b0b2731cd56d2159e241a3",
"assets/NOTICES": "55866e23d6ff66fb4cc8367363653970",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "16ddffe0be869c393c3d21bd56a05263",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "577288aee5702264a33d78fae8c66d91",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "a763f48beb3c3f38ae611a1846d899d2",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "53beb48bea84ff7a7d255ae12343e2e0",
"assets/packages/google_places_flutter/images/location.json": "afa33acf2c340246c901718f4efdfccf",
"assets/packages/map_launcher/assets/icons/amap.svg": "00409535b144c70322cd4600de82657c",
"assets/packages/map_launcher/assets/icons/apple.svg": "6fe49a5ae50a4c603897f6f54dec16a8",
"assets/packages/map_launcher/assets/icons/baidu.svg": "22335d62432f9d5aac833bcccfa5cfe8",
"assets/packages/map_launcher/assets/icons/citymapper.svg": "58c49ff6df286e325c21a28ebf783ebe",
"assets/packages/map_launcher/assets/icons/doubleGis.svg": "ab8f52395c01fcd87ed3e2ed9660966e",
"assets/packages/map_launcher/assets/icons/google.svg": "cb318c1fc31719ceda4073d8ca38fc1e",
"assets/packages/map_launcher/assets/icons/googleGo.svg": "cb318c1fc31719ceda4073d8ca38fc1e",
"assets/packages/map_launcher/assets/icons/here.svg": "aea2492cde15953de7bb2ab1487fd4c7",
"assets/packages/map_launcher/assets/icons/mapswithme.svg": "87df7956e58cae949e88a0c744ca49e8",
"assets/packages/map_launcher/assets/icons/osmand.svg": "639b2304776a6794ec682a926dbcbc4c",
"assets/packages/map_launcher/assets/icons/osmandplus.svg": "31c36b1f20dc45a88c283e928583736f",
"assets/packages/map_launcher/assets/icons/petal.svg": "76c9cfa1bfefb298416cfef6a13a70c5",
"assets/packages/map_launcher/assets/icons/tencent.svg": "4e1babec6bbab0159bdc204932193a89",
"assets/packages/map_launcher/assets/icons/tomtomgo.svg": "493b0844a3218a19b1c80c92c060bba7",
"assets/packages/map_launcher/assets/icons/waze.svg": "311a17de2a40c8fa1dd9022d4e12982c",
"assets/packages/map_launcher/assets/icons/yandexMaps.svg": "3dfd1d365352408e86c9c57fef238eed",
"assets/packages/map_launcher/assets/icons/yandexNavi.svg": "bad6bf6aebd1e0d711f3c7ed9497e9a3",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "c86fbd9e7b17accae76e5ad116583dc4",
"canvaskit/canvaskit.js.symbols": "38cba9233b92472a36ff011dc21c2c9f",
"canvaskit/canvaskit.wasm": "3d2a2d663e8c5111ac61a46367f751ac",
"canvaskit/chromium/canvaskit.js": "43787ac5098c648979c27c13c6f804c3",
"canvaskit/chromium/canvaskit.js.symbols": "4525682ef039faeb11f24f37436dca06",
"canvaskit/chromium/canvaskit.wasm": "f5934e694f12929ed56a671617acd254",
"canvaskit/skwasm.js": "445e9e400085faead4493be2224d95aa",
"canvaskit/skwasm.js.symbols": "741d50ffba71f89345996b0aa8426af8",
"canvaskit/skwasm.wasm": "e42815763c5d05bba43f9d0337fa7d84",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "2704101cb06ce66e2000356a312be25c",
"flutter.js": "c71a09214cb6f5f8996a531350400a9a",
"icons/app_launcher_icon.png": "990395737486e52912bf381eaf1bb397",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"index.html": "78ce4c0be09478ed2f304ab6d9f48767",
"/": "78ce4c0be09478ed2f304ab6d9f48767",
"main.dart.js": "674e69408d531c933b412fdbfbe091be",
"version.json": "a2e37c7150b618eaaf7d4aa3338668b1"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
