module engine.cache;

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
            }
        }
    }

    void empty()
    {
        foreach (string name, CacheItem!T item; items) {
            items.remove(name);
        }
    }

    bool has(string name)
    {
        if (name in items) {
            return true;
        } else {
            return false;
        }
    }

    T get(string name)
    in
    {
        assert(has(name));
    }
    body
    {
        return items[name].data;
    }

    void set(string name, T item)
    {
        if (name in items) {
            items[name].age = 0;
            items[name].data = item;
        } else {
            items[name] = new CacheItem!T(item);
        }
    }
}