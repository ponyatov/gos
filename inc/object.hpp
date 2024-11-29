/// @file
#pragma once

#include <stdlib.h>
#include <string>

class Object {
    size_t ref;
    std::string value;

   public:
    Object();
    Object(std::string V);
    virtual ~Object();
};
