export const homeHeroDefaults = {
  homeHeroTitle: '',
  homeHeroSubtitle: '',
  homeHeroEnabled: false,
  homeHeroSlides: [] as {
    image: string;
    mobileImage: string;
    type?: 'image' | 'video';
    mobileType?: 'image' | 'video';
  }[],
  homeHeroParallax: true,
  homeHeroAutoplay: false,
  homeHeroRandom: false,
  homeHeroInterval: 8,
  homeHeroFit: 'cover' as const,
  homeHeroPosition: 'center' as const,
  homeHeroOverlay: 25
};
