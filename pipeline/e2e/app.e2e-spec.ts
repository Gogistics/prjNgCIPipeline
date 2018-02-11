import { AppPage } from './app.po';

describe('pipeline App', () => {
  let page: AppPage;

  beforeEach(() => {
    page = new AppPage();
  });

  it('should display welcome message', () => {
    page.navigateTo();
    expect(page.getParagraphText()).toEqual('Let\'s Go with Angular on Dock');
  });
});
