//
// Screen
//

class RootView extends View {

    //WindowView activeWindow;
    View grabbedView;
  
    RootView(Point origin, Size size)
    {
        super(origin, size);
        
        this.setStrokeColor(null);
        this.setFillColor(Color.LightGray);
    }

    //View hitTestForEvent(Point point)
    //{
    //    return this;
    //}

    //void mouseButtonPressed(Point mousePoint, int mouseButton)
    //{
    //    println("RootView.mouseButtonPressed()");
    //    this.grabbedView = super.hitTestForEvent(mousePoint);

    //    Point childPoint = mousePoint.minus(this.grabbedView.getScreenOrigin());
    //    MouseEvent mouseEvent = new MouseEvent(MouseEvent.ButtonPressed, childPoint, mouseButton, 0);

    //    this.grabbedView.sendEvent(mouseEvent);
    //}

    //void mousePositionChanged(Point mousePoint)
    //{
    //    Point childPoint = mousePoint.minus(this.grabbedView.getScreenOrigin());
    //    MouseEvent mouseEvent = new MouseEvent(MouseEvent.PositionChanged, childPoint, mouseButton, 0);

    //    this.grabbedView.sendEvent(mouseEvent);
    //}

    //void mouseButtonReleased(Point mousePoint, int mouseButton)
    //{
    //    Point childPoint = mousePoint.minus(this.grabbedView.getScreenOrigin());
    //    MouseEvent mouseEvent = new MouseEvent(MouseEvent.ButtonReleased, childPoint, mouseButton, 0);

    //    this.grabbedView.sendEvent(mouseEvent);
    //}

    View sendEvent(Event event)
    {
        if (event instanceof MouseEvent)
        {
            MouseEvent mouseEvent = (MouseEvent) event;
                        
            if (mouseEvent.eventType == MouseEvent.ButtonPressed)
            {
                this.grabbedView = mouseEvent.hitTestForView(this, mouseEvent.mousePoint);
            }
            
            Point grabbedMousePoint = mouseEvent.mousePoint.minus(this.grabbedView.getScreenOrigin());
            MouseEvent grabbedMouseEvent = new MouseEvent(mouseEvent.eventType, grabbedMousePoint, mouseEvent.mouseButton, mouseEvent.mouseScroll);

            this.grabbedView.handleEvent(grabbedMouseEvent);

            return this.grabbedView;
        }

        return super.sendEvent(event);
    }

    //void activateWindow(WindowView windowView)
    //{
    //    if (this.activeWindow != null)
    //    {
    //        this.activeWindow.deactivate();
    //    }
        
    //    this.activeWindow = windowView;
        
    //    this.activeWindow.activate();
    //}

}