module engine.util.cache;

import std.stdio;

class CacheItem(T)
{
    T     data;
    float age;

    this(T pData)
    {
        data = pData;
    }
}

class Cache(T)
{
    float                 maxAge;
    CacheItem!(T)[string] items;

    this(float pMaxAge)
    {
        maxAge = pMaxAge;
    }

    void collect(float delta)
    {
        foreach (string name, CacheItem!T item; items) {
            item.age += delta;
            if (item.age >= maxAge) {
                debug writeln("Cleaning up " ~ name);
                items.remove(name);
                delete item;
            }
        }
    }

    void empty()
    {
        foreach (string name, CacheItem!T item; items) {
            items.remove(name);
            delete item;
        }
    }

    T get(string name)
    {
        if (name in items) {
            return items[name].data;
        }
        return null;
    }

    void set(string name, T item)
    {
        if (name in items) {
            delete items[name].data;
            items[name].age = 0;
            items[name].data = item;
        } else {
            items[name] = new CacheItem!T(item);
        }
    }
}