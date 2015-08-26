module dspace.core.collision.projection;

import std.math;

struct Projection
{
    float start;
    float end;

    float overlap(Projection other) const
    {
        float offset;
        auto m1 = (start + end) / 2;
        auto r1 = abs(start - end) / 2;

        auto m2 = (other.start + other.end) / 2;
        auto r2 = abs(other.start - other.end) / 2;

        if (abs(m1 - m2) < (r1 + r2)) {
            offset = (r1 + r2) - abs(m1 - m2);
            if (m1 < m2) {
                offset = -offset;
            }
        }
        return offset;
    }
}