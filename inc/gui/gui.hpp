#pragma once

#include <assert.h>
#include <string>
#include "object.hpp"
#include <SDL2/SDL.h>

class GUI : public Object {
    SDL_Window* window;
    int x, y, w, h;
    static const int X = 50, Y = 50;
    static const int W = 240, H = 320;

    SDL_Renderer* renderer;
    SDL_Event event;

   public:
    GUI(std::string title, int x = GUI::X, int y = GUI::Y, int w = GUI::W,
        int h = GUI::Y);
    GUI(std::string title) : GUI(title, GUI::X, GUI::Y, GUI::W, GUI::Y) {}
    GUI(const char* title) : GUI(title, GUI::X, GUI::Y, GUI::W, GUI::Y) {}
    ~GUI();
    bool loop(void);
};
