//
// Geometry
//

class Point {

    private int x;
    private int y;
  
    Point(Point point)
    {
        this.x = point.x;
        this.y = point.y;
    }
  
    Point()
    {
        this.x = 0;
        this.y = 0;
    }

    Point(int x, int y)
    {
        this.x = x;
        this.y = y;
    }

    public String toString()
    {
        return "{ " + x + ", " + y + " }";
    }

    Point plus(Point point)
    {
        return new Point(this.x + point.x, this.y + point.y);
    }

    Point minus(Point point)
    {
        return new Point(this.x - point.x, this.y - point.y);
    }

}

class Margin {
  
    private int left;
    private int top;
    private int right;
    private int bottom;

    Margin(Margin margin)
    {
        this.left   = margin.left;
        this.top    = margin.top;
        this.right  = margin.right;
        this.bottom = margin.bottom;
    }

    Margin(int left, int top, int right, int bottom)
    {
        this.left   = left;
        this.top    = top;
        this.right  = right;
        this.bottom = bottom;
    }

    Margin addLeftTopPoint(Point point)
    {
        return new Margin(this.left + point.x, this.top + point.y, 0, 0);
    }

    Point getLeftTopPoint()
    {
        return new Point(this.left, this.top);
    }
    
}

class Size {

    public final static int Wrap = Integer.MIN_VALUE;
    public final static int Fill = Integer.MAX_VALUE;
  
    private int width;
    private int height;

    Size()
    {
        this.width  = Size.Wrap;
        this.height = Size.Wrap;
    }

    Size(int width, int height)
    {
        this.width  = width;
        this.height = height;
    }

    Size(Size size)
    {
        this.width  = size.width;
        this.height = size.height;
    }

}

class Rect {
  
    int x;
    int y;
    int width;
    int height;
    
    Rect(int x, int y, int width, int height)
    {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }
  
}

static class Color {
  
    int red;
    int green;
    int blue;
    int alpha;

    public final static Color Clear = new Color(255, 255, 255, 0);
    public final static Color White = new Color(255, 255, 255, 255);
    public final static Color LightGray  = new Color(208, 208, 208, 255);
    public final static Color Gray  = new Color(153, 153, 153, 255);
    public final static Color DarkGray  = new Color(63, 63, 63, 255);
    public final static Color Black = new Color(0, 0, 0, 255);

    Color(int red, int green, int blue, int alpha)
    {
        this.red = red;
        this.green = green;
        this.blue = blue;
        this.alpha = alpha;
    }

    int getRed() { return this.red; }
    int getGreen() { return this.green; }
    int getBlue() { return this.blue; }
    int getAlpha() { return this.alpha; }

}

class Action<T> {
  
  void invoke(T arg)
  {
  }
  
}

class Gravity {

    int value;
  
    public final static int Center = 0;
    public final static int Left   = 1 << 0;
    public final static int Top    = 1 << 1;
    public final static int Right  = 1 << 2;
    public final static int Bottom = 1 << 3;

    Gravity(int value)
    {
        this.value = value;
    }
  
}

class Align {
  
    public final static int Left   = LEFT;
    public final static int Center = CENTER;
    public final static int Right  = RIGHT;
    
}