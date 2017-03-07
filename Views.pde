//
// Views
//

import java.util.*;

interface Frame {
  
    void foo();
  
}

class Layer {
  
    Rect frame;

    void setOrigin(Point origin)
    {
        this.frame = new Rect(origin.x, origin.y, this.frame.width, this.frame.height);
    }

    void setSize(Size size)
    {
        this.frame = new Rect(this.frame.x, this.frame.y, size.width, size.height);
    }
  
}


class Shape {

    protected List<Shape> children;
    protected Shape       parent;

    Shape()
    {
        this.children = new ArrayList<Shape>();
        this.parent   = null;
    }

    void setParent(Shape parent)
    {
        this.parent = parent;
    }

    Shape getParent()
    {
        return this.parent;
    }

    Shape addChild(Shape child)
    {
        child.setParent(this);
        this.children.add(child);
        
        return this;
    }

    void removeChild(Shape child)
    {
        child.setParent(null);

        this.children.remove(child);
    }

    List<Shape> getChildren()
    {
        return new ArrayList<Shape>(this.children);
    }

    Shape getRootShape()
    {
        Shape shape = this;
        
        while (shape.getParent() != null)
        {
            shape = shape.getParent();
        }
        
        return shape;
    }

    void bringToFront()
    {
        Shape parent = this.getParent();
        
        parent.removeChild(this);
        parent.addChild(this);
    }

}

class Control {

}


class View extends Shape {

    public final static int StrokeInside = -1;
    public final static int StrokeOutside = 1;

    protected Margin layoutMargin;
    protected Size   layoutSize;
    protected Point  frameOrigin;
    protected Size   frameSize;
    
    private   Color fillColor      = Color.White;
    protected Color strokeColor    = Color.Black;
    protected float strokeWidth    = 3.0;
    protected int   strokePosition = StrokeOutside;
    protected float cornerRadius   = 0.0;

    protected View focusedView;

    protected boolean acceptsEvents = false;

    ArrayList<View> childViews;
    //View            parentView;

    View(Point origin, Size layoutSize)
    {
        this.layoutMargin = new Margin(origin.x, origin.y, 0, 0);
        this.layoutSize  = layoutSize;

        this.childViews  = new ArrayList<View>();
        //this.parentView  = null;

        this.frameOrigin = origin;
        this.frameSize   = layoutSize;
    }

    void setFocused()
    {
        View parentView = this.getParentView();
        
        if (parentView.focusedView != null)
        {
            parentView.focusedView.focusLost();
        }
        
        parentView.focusedView = this;
        
        parentView.focusedView.focusGained();
    }

    void focusGained()
    {
    }
    
    void focusLost()
    {
    }
    
 //
 // Geometry
 //

    //private void setFrameOrigin(Point origin)
    //{
    //    this.frameOrigin = origin;
    //}

    //Point getFrameOrigin()
    //{
    //    return new Point(this.frameOrigin);
    //}

    Point getScreenOrigin()
    {
        View view = this.getParentView();
        Point origin = this.frameOrigin;
        
        while (view != null)
        {
            origin = origin.plus(view.frameOrigin);
            
            view = view.getParentView();
        }
        
        return origin;
    }

    void setLayoutMargin(Margin layoutMargin)
    {
        //this.layoutMargin = layoutMargin;
        this.layoutMargin.left = layoutMargin.left;
        this.layoutMargin.top = layoutMargin.top;
        
        this.requestLayout();
        //this.frameOrigin = new Point(layoutMargin.left, layoutMargin.top);
    }

    Margin getLayoutMargin()
    {
        //return new Margin(this.layoutMargin);
        return this.layoutMargin;
    }

    void setLayoutSize(Size layoutSize)
    {
        this.layoutSize = layoutSize;
        //this.frameSize = layoutSize;
        
        this.requestLayout();
    }
    
    Size getLayoutSize()
    {
        //return new Size(this.layoutSize);
        return this.layoutSize;
    }

 //
 // Hierarchy
 //

    List<View> getChildViews()
    {
        return new ArrayList<View>(this.childViews);
    }
 
    View addChildViews(View... childViews)
    {
        for (int i = 0; i < childViews.length; i++)
        {
            this.addChildView(childViews[i]);
        }
        
        return this;
    }
    
    View addChildView(View childView)
    {
        childView.setParentView(this);
        
        this.childViews.add(childView);
        
        return this;
    }

    void removeChildView(View childView)
    {
        childView.setParentView(null);

        this.childViews.remove(childView);
    }

    void setParentView(View parentView)
    {
        //this.parentView = parentView;
        this.setParent(parentView);
    }

    View getParentView()
    {
        //return parentView;
        return (View) this.getParent();
    }
    
    RootView getRootView()
    {
        View view = this;
        
        while (view.getParentView() != null)
        {            
            view = view.getParentView();
        }
        
        return (RootView) view;
    }

    WindowView getWindowView()
    {
        View view = this.getParentView();
        
        while (view != null)
        {            
            if (view instanceof WindowView)
                return (WindowView) view;
                
            view = view.getParentView();
        }
        
        return null;
    }
    
    void bringToFront()
    {
        View parentView = this.getParentView();
        
        parentView.childViews.remove(this);
        parentView.childViews.add(this);
    }

 //
 // Properties
 // 

    void setFillColor(Color fillColor)
    {
        this.fillColor = fillColor;
    }
    
    Color getFillColor()
    {
        return this.fillColor;
    }

    void setStrokeColor(Color strokeColor)
    {
        this.strokeColor = strokeColor;
    }
    
    Color getStrokeColor()
    {
        return this.strokeColor;
    }

    View setStrokePosition(int strokePosition)
    {
        this.strokePosition = strokePosition;
        
        return this;
    }
    
 //
 // Events
 //

    boolean acceptsEvents()
    {
        return this.acceptsEvents;
    }

    View sendEvent(Event event)
    {
        println("View.sendEvent()");
        return event.dispatchForView(this);
    }
    
    View hitTestForEvent(MouseEvent event, Point mousePoint)
    {
        // null => Doesn't handle events 
        // this => Overrides event
        // event.hitTestForView() => Normall hierarchy
        
        return event.hitTestForView(this, mousePoint);
    }
    
    void handleEvent(MouseEvent event)
    {
        if (event.eventType == MouseEvent.ButtonPressed)
            mouseButtonPressed(event.mousePoint, event.mouseButton);
        else if (event.eventType == MouseEvent.PositionChanged)
            mousePositionChanged(event.mousePoint);
        else if (event.eventType == MouseEvent.ButtonReleased)
            mouseButtonReleased(event.mousePoint, event.mouseButton);
        else if (event.eventType == MouseEvent.ScrollChanged)
            mouseScrollChanged(event.mouseScroll);
    }

//    View viewAtPoint(Point point, boolean recursive)
//    {
//        return this;
//    }

    boolean containsPoint(Point point)
    {
        return point.x >= 0 && point.x < this.layoutSize.width &&
               point.y >= 0 && point.y < this.layoutSize.height;
    }

    void mouseButtonPressed(Point mousePoint, int mouseButton)
    {
        println("mouseButtonPressed", this, mousePoint);
    }

    void mousePositionChanged(Point mousePoint)
    {
        println("mousePositionChanged", this, mousePoint);
    }

    void mouseButtonReleased(Point mousePoint, int mouseButton)
    {
        println("mouseButtonReleased", this, mousePoint);
    }

    void mouseScrollChanged(int mouseScroll)
    {
        println("mouseScrollChanged", this, mouseScroll);
    }
    
 //
 // Drawing
 //
    
    void draw(PGraphics g)
    {
        g.pushMatrix();
        
        g.translate(this.frameOrigin.x, this.frameOrigin.y);

        if (this.fillColor != null)
        {
            g.fill(this.fillColor.getRed(), this.fillColor.getGreen(), this.fillColor.getBlue(), this.fillColor.getAlpha());
            g.noStroke();

            if (this.strokePosition == StrokeOutside)
            {
                g.rect(0 - this.strokeWidth / 2.0, 0 - this.strokeWidth / 2.0,
                       this.layoutSize.width + this.strokeWidth, this.layoutSize.height + this.strokeWidth,
                       this.cornerRadius);
            } else {
                g.rect(0 + this.strokeWidth / 2.0, 0 + this.strokeWidth / 2.0,
                       this.layoutSize.width - this.strokeWidth, this.layoutSize.height - this.strokeWidth,
                       this.cornerRadius);
            }
        }

        this.drawView(g);
        this.drawChildViews(g);

        if (this.strokeColor != null)
        {
            g.stroke(this.strokeColor.getRed(), this.strokeColor.getGreen(), this.strokeColor.getBlue(), this.strokeColor.getAlpha());
            g.strokeWeight(this.strokeWidth);
            g.noFill();        

            if (this.strokePosition == StrokeOutside)
            {
                g.rect(0 - this.strokeWidth / 2.0, 0 - this.strokeWidth / 2.0,
                       this.layoutSize.width + this.strokeWidth, this.layoutSize.height + this.strokeWidth,
                       this.cornerRadius);
            } else {
                g.rect(0 + this.strokeWidth / 2.0, 0 + this.strokeWidth / 2.0,
                       this.layoutSize.width - this.strokeWidth, this.layoutSize.height - this.strokeWidth,
                       this.cornerRadius);
            }
        }
        
        g.popMatrix();
    }
    
    void drawView(PGraphics g) { }

    void drawChildViews(PGraphics g)
    {
        ListIterator<View> iter = this.childViews.listIterator(0);

        while (iter.hasNext())
        {
            View childView = iter.next();
            
            childView.draw(g);
        }
    }
    
 //
 // Layout
 //

    int layoutGravity = Gravity.Left | Gravity.Top;
    Size measuredSize = new Size();
    boolean needsLayout = true;

    void requestLayout()
    {
        println("requestLayout()");
        
        this.requestLayoutChildren();
        
        for (View view = this; view != null; view = view.getParentView())
        {
            view.needsLayout = true;            
        }
    }
    
    void requestLayoutChildren()
    {
        ListIterator<View> iter = this.childViews.listIterator(0);
        while (iter.hasNext())
        {
            View childView = iter.next();
            
            //if ((childView.layoutGravity & Gravity.Right) == Gravity.Right)
            {
                childView.needsLayout = true;
            
                childView.requestLayoutChildren();
            }
        }
    }
    
    boolean needsLayout() { return this.needsLayout; }

    void setLayoutGravity(int layoutGravity) { this.layoutGravity = layoutGravity; }

    void measureView()
    {
        this.measureChildViews();
        
        int width = this.layoutSize.width, height = this.layoutSize.height;

        //if (this.layoutSize.width == Size.Wrap || this.layoutSize.height == Size.Wrap ||
        //    this.layoutSize.width == Size.Fill || this.layoutSize.height == Size.Fill)
        {
            if (this.layoutSize.width == Size.Fill) width = 0;
            if (this.layoutSize.height == Size.Fill) height = 0;
            
            ListIterator<View> iter = this.childViews.listIterator(0);
            while (iter.hasNext())
            {
                View childView = iter.next();
                
                if (this.layoutSize.width == Size.Wrap  || this.layoutSize.width == Size.Fill) {
                    width  = max(width, childView.layoutMargin.left + childView.measuredSize.width);
                    println("here");
                }

                if (this.layoutSize.height == Size.Wrap || this.layoutSize.height == Size.Fill)
                    height = max(height, childView.layoutMargin.top + childView.measuredSize.height); 
            }    
        }
        
        this.measuredSize = new Size(width, height);
    }
    
    void measureChildViews()
    {
        ListIterator<View> iter = this.childViews.listIterator(0);
        while (iter.hasNext())
        {
            View childView = iter.next();
            
            //if (childView.needsLayout())
            {
                childView.measureView();
            }
        }
    }

    void layoutView(Rect bounds)
    {
        int left = this.layoutMargin.left, top = this.layoutMargin.top,
            width = this.measuredSize.width, height = this.measuredSize.height;
            
        if (this.layoutSize.width == Size.Fill) {
            width = bounds.width - this.layoutMargin.left - this.layoutMargin.right;
            println("here");
        } else if ((this.layoutGravity & Gravity.Left) == Gravity.Left)
            left = this.layoutMargin.left;
        else if ((this.layoutGravity & Gravity.Right) == Gravity.Right)
            left = bounds.width - this.measuredSize.width - this.layoutMargin.left;
        else
            left = round((bounds.width - this.measuredSize.width) / 2.0 + this.layoutMargin.left - this.layoutMargin.right);

        if (this.layoutSize.height == Size.Fill)
            height = bounds.height - this.layoutMargin.top - this.layoutMargin.bottom;
        else if ((this.layoutGravity & Gravity.Top) == Gravity.Top)
            top = this.layoutMargin.top;
        else if ((this.layoutGravity & Gravity.Bottom) == Gravity.Bottom)
            top = bounds.height - this.measuredSize.height - this.layoutMargin.top;
        else
            top = round((bounds.height - this.measuredSize.height) / 2.0 + this.layoutMargin.top - this.layoutMargin.bottom);

        this.frameOrigin.x = left; this.frameOrigin.y = top;
        this.frameSize.width = width; this.frameSize.height = height;

        ListIterator<View> iter = this.childViews.listIterator(0);
        while (iter.hasNext())
        {
            View childView = iter.next();

            //if (childView.needsLayout())
            {
                childView.layoutView(new Rect(0, 0, width, height));
            }
        }

        this.needsLayout = false;
    }

    //void layout(Rect bounds)
    //{
    //    this.measure();

    //    int left = 0, top = 0;
        
    //    if (layoutSize.width == Size.Fill)
    //        this.frameSize.width = bounds.width;
    //    else
    //        this.frameSize.width = this.measuredSize.width;

    //    if (layoutSize.height == Size.Fill)
    //        this.frameSize.height = bounds.height;
    //    else
    //        this.frameSize.height = this.layoutSize.height;

    //    ListIterator<View> iter = this.childViews.listIterator(0);
    //    while (iter.hasNext())
    //    {
    //        View childView = iter.next();

    //        childView.layout(new Rect(0, 0, this.frameSize.width, this.frameSize.height));
    //    }
    //}
    
}