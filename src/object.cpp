#include "object.hpp"

Object::Object() { ref = 0; }
Object::Object(std::string V) : Object() { value = V; }

Object::~Object() {}
