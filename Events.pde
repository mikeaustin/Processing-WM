//
// Events
//

import java.util.ListIterator;

class Event {
  
    private int foo;

    View dispatchForView(View view)
    {
        return view;
    }
  
}

class MouseEvent extends Event {

    public final static String ButtonPressed   = "ButtonPressed";
    public final static String ButtonReleased  = "ButtonReleased";
    public final static String PositionChanged = "PositionChanged";
    public final static String ScrollChanged   = "ScrollChanged";

    public String eventType;
    public Point  mousePoint;
    public int    mouseButton;
    public int    mouseScroll;

    MouseEvent(String eventType, Point mousePoint, int mouseButton, int mouseScroll)
    {
        this.eventType   = eventType;
        this.mousePoint  = mousePoint;
        this.mouseButton = mouseButton;
        this.mouseScroll = mouseScroll;
    }

    View dispatchForView(View view)
    {
        View targetView = this.hitTestForView(view, this.mousePoint);
        
        targetView.handleEvent(this);
        
        return targetView;
    }  

    View hitTestForView(View view, Point mousePoint)
    {
        if (view.containsPoint(mousePoint))
        {
            //ListIterator<View> iter = view.childViews.listIterator(view.childViews.size());
            ListIterator<View> iter = view.getChildViews().listIterator(view.getChildViews().size());
            while (iter.hasPrevious())
            {
                View childView = iter.previous();
    
                Point childPoint = new Point(mousePoint.x - childView.frameOrigin.x, mousePoint.y - childView.frameOrigin.y);
  
                View targetView = childView.hitTestForEvent(this, childPoint);

                if (targetView != null && targetView.acceptsEvents())
                //if (targetView != null)
                {
                    return targetView;
                }
            }
            
            return view;
        }

        return null;
    }

}