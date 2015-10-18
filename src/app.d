import dspace.dspace;

version(unittest)
{
    void main()
    {
        import std.stdio;
        writeln("Unit tests successful.");
    }
}
else
{
    void main()
    {
        auto game = new DSpace();
        game.run();
    }
}