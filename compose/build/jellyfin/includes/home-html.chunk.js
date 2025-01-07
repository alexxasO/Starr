"use strict"; (self.webpackChunk = self.webpackChunk || []).push([[8372], {
  5939: function (a, e, t) {
    t.r(e),
      e.default = `
    <div id="indexPage" style="outline:0" data-role="page" data-dom-cache="true" class="page homePage libraryPage allLibraryPage backdropPage pageWithAbsoluteTabs withTabs" data-backdroptype="movie,series,book">
      <style>
        .featurediframe {width: 95vw; height: 23.5em; display: block; border: 0px solid #000; margin: 0 auto; margin-bottom: 0em; margin-top: 1em;}
	@media (min-width: 2601px) {.featurediframe {height: 50em;} }
        @media (min-width: 2000px) and (max-width: 2600px) {.featurediframe {height: 20em; font-size: 175%;} .layout-desktop #homeTab .sections.homeSectionsContainer {margin-top: -3em !important;} }
        @media (max-width: 1000px) and (orientation: portrait) {.featurediframe {height: 46vh;} }
        @media (max-width: 1000px) and (orientation: landscape) {.featurediframe {height: 98vh;} }
        @media (max-width: 400px) and (orientation: portrait) {.featurediframe {height: 52vh;} }
        @media (max-height: 400px) and (orientation: landscape) {.featurediframe {height: 100vh;} }
        @media screen and (aspect-ratio: 4/3) {.featurediframe {height: 27em;} }
        @media screen and (aspect-ratio: 3/4) {.featurediframe {height: 27em;} }
        @media screen and (aspect-ratio: 16/10) and (max-height: 1200px) {.featurediframe {height: 34em;} }
        @media screen and (aspect-ratio: 10/16) and (max-height: 1280px) {.featurediframe {height: 25em;} }
      </style>
      <div class="tabContent pageTabContent" id="homeTab" data-index="0">
      <div id="announcementBanner" style="
        background-color: #2b303b;
        color: #ffffff;
        border: 1px solid #4c566a;
        border-radius: 4px;
        padding: 16px;
        font-family: 'Roboto', sans-serif;
        font-size: 16px;
        text-align: center;
        margin: 10px 35px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        overflow: hidden;
        white-space: nowrap;
      ">
        <span id="announcementText" style="flex-grow: 1;"></span>
        <button id="closeAnnouncement" style="
          background: none;
          border: none;
          color: #ffffff;
          font-size: 20px;
          cursor: pointer;
          padding: 0 8px;
        " aria-label="Close announcement">
          &times;
        </button>
      </div>
      <iframe class="featurediframe" src="/web/ui/spotlight.html"></iframe>
      <div class="sections"></div></div><div class="tabContent pageTabContent" id="favoritesTab" data-index="1"> <div class="sections"></div></div></div>`;
  }
}]);
document.addEventListener("DOMContentLoaded", () => {
  const homeTab = document.getElementById("homeTab");
  const spotlightIframe = homeTab.querySelector(".featurediframe");

  const observer = new MutationObserver(() => {
    const isHomeTabActive = homeTab.classList.contains("is-active");
    spotlightIframe.style.display = isHomeTabActive ? "block" : "none";
  });
  observer.observe(homeTab, { attributes: true, attributeFilter: ["class"] });
});

// <!-- TODO Announcement banner script -->
const announcementBanner = document.getElementById('announcementText');
const announcementText = 'Un Discord à été mis en place par ici : <a href="https://discord.antxis.fr">https://discord.antxis.fr</a>';

if (announcementText) {
  announcementBanner.innerHTML = announcementText;
}

// Script to handle the close button
document.getElementById('closeAnnouncement').addEventListener('click', function() {
  document.getElementById('announcementBanner').style.display = 'none';
});