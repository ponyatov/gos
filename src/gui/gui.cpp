#include "gui.hpp"

GUI::GUI(std::string title, int x, int y, int w, int h) : Object(title) {
    assert(!SDL_Init(SDL_INIT_EVERYTHING));
    assert(window =
               SDL_CreateWindow(title.c_str(), x, y, w, h, SDL_WINDOW_SHOWN));
    assert(
        renderer = SDL_CreateRenderer(
            window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC));
}

GUI::~GUI() {
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
    fprintf(stderr, "sdl quit\n");
}

bool GUI::loop(void) {
    while (SDL_PollEvent(&event)) {
        switch (event.type) {
            case SDL_QUIT:
                return false;
            case SDL_KEYDOWN:
                return false;
        }
    }
    return true;
}
