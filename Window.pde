//
// Window
//

class WindowView extends View {

    public static final boolean Separator = true; 
    public static final boolean NoSeparator = false; 
  
    private View shadowView;
    private LabelView titleLabelView;
    private ButtonView closeButtonView;
    private ButtonView maximizeButtonView;
    private View contentView;
    
    private boolean needsRedraw;
    private Point lastMousePoint;
    private int resizeMode;
    private boolean hasSeparator;
    boolean clickToFront = true;

    private Color normalColor = Color.White,
                  activeColor = Color.White;

    PGraphics contentImage;

    WindowView(Point origin, Size size)
    {
        super(origin, size);

        View contentView = new View(new Point(0, 30), new Size(size.width, size.height - 30));
        contentView.strokeColor = null;

        initialize(origin, size, contentView, false, P2D);
    }
    
    WindowView(Point origin, Size size, String graphicsType)
    {
        super(origin, size);

        View contentView = new View(new Point(0, 30), new Size(size.width, size.height - 30));
        contentView.strokeColor = null;

        initialize(origin, size, contentView, false, graphicsType);
    }

    WindowView(Point origin, Size size, View contentView, boolean separator)
    {
        super(origin, size);

        initialize(origin, size, contentView, separator, P2D);
    }

    WindowView(Point origin, Size size, View contentView, boolean separator, String graphicsType)
    {
        super(origin, size);

        initialize(origin, size, contentView, separator, graphicsType);
    }
  
    void initialize(Point origin, Size size, View contentView, boolean separator, String graphicsType)
    {
        this.contentImage = createGraphics(size.width, size.height, graphicsType);
        this.needsRedraw = true;

        this.hasSeparator = separator;
        this.acceptsEvents = true;
        this.cornerRadius = 5;
        
        super.addChildView(
          //this.shadowView = new ShadowView(new Point(-3, -3), new Size(size.width + 6, size.height + 6))
          this.shadowView = new ShadowView(new Point(-3, -3), new Size(Size.Fill, size.height + 6))
        );
        this.shadowView.fillColor = Color.Clear;
        this.shadowView.cornerRadius = 11;
        this.shadowView.strokeWidth = 7;
        this.shadowView.strokeColor = Color.Clear;
        //this.shadowView.setLayoutSize(new Size(Size.Fill, size.height + 6));

        this.contentView = contentView;
        if (this.hasSeparator)
        {
            this.contentView.setLayoutMargin(new Margin(0, 39, 0, 0));
            this.contentView.setLayoutSize(new Size(size.width, size.height - 39));
        }
        else
        {
            this.contentView.setLayoutMargin(new Margin(0, 26, 0, 0));
            this.contentView.setLayoutSize(new Size(size.width, size.height - 26));
        }
        this.contentView.strokeWidth = 0.0f;
        this.contentView.strokeColor = null;
        
        super.addChildView(
          this.titleLabelView = new LabelView(new Point(), new Size(size.width, 23))
         );
        this.titleLabelView.setTextColor(Color.White);
        
        super.addChildView(this.contentView);

        super.addChildView(
          this.closeButtonView = new ButtonView(new Point(3, 3), new Size(20, 20), "×")
        );
        this.closeButtonView.strokeColor = null;
        this.closeButtonView.strokeWidth = 0;
        this.closeButtonView.titleLabelView.setLayoutMargin(new Margin(-3, -4, 0, 0));
        this.closeButtonView.titleLabelView.setLayoutSize(new Size(25, 25));

        super.addChildView(
          this.maximizeButtonView = new ButtonView(new Point(size.width - 20 - 3, 3), new Size(20, 20), "=")
        );
        this.maximizeButtonView.setLayoutMargin(new Margin(3, 3, 3, 3));
        this.maximizeButtonView.setLayoutGravity(Gravity.Top | Gravity.Right);
        this.maximizeButtonView.strokeColor = null;
        this.maximizeButtonView.strokeWidth = 0;
        this.maximizeButtonView.titleLabelView.setLayoutMargin(new Margin(-3, -4, 0, 0));
        this.maximizeButtonView.titleLabelView.setLayoutSize(new Size(25, 25));

        this.deactivate();
    }

    boolean containsPoint(Point point)
    {
        return point.x >= 0 - 10 && point.x < this.layoutSize.width + 10 * 2 &&
               point.y >= 0 - 10 && point.y < this.layoutSize.height + 10 * 2;
    }

    WindowView addChildViews(View... childViews)
    {
        super.addChildViews(childViews);
                
        return this;
    }

    View addChildView(View childView)
    {
        this.contentView.addChildView(childView);
        
        return this;
    }

    Size getContentSize()
    {
        return this.contentView.getLayoutSize();
    }

    void needsRedraw(boolean needsRedraw)
    {
        this.needsRedraw = needsRedraw;
    }

    boolean needsRedraw()
    {
        return this.needsRedraw;
    }

    View hitTestForEvent(MouseEvent mouseEvent, Point mousePoint)
    {
        //if (mouseEvent.eventType == MouseEvent.ButtonPressed && this.containsPoint(mousePoint))
        if (this.containsPoint(mousePoint))
        {
            //this.getRootView().activateWindow(this);
            this.setFocused();
            
            if (this.clickToFront) this.bringToFront();
        }
        
        //return super.hitTestForEvent(mouseEvent, mousePoint);
        return mouseEvent.hitTestForView(this, mousePoint);
    }

    void focusGained()
    {
        this.activate();
    }

    void focusLost()
    {
        this.deactivate();
    }

    void activate()
    {
        this.titleLabelView.setTextColor(this.activeColor);
        this.shadowView.strokeColor = new Color(128, 128, 128, 224);
        this.shadowView.strokeWidth = 7.0f;
        this.shadowView.cornerRadius = 11.0f;
    }
    
    void deactivate()
    {
        this.titleLabelView.setTextColor(this.normalColor);
        this.shadowView.strokeColor = new Color(128, 128, 128, 128);
        this.shadowView.strokeWidth = 3.0f;
        this.shadowView.cornerRadius = 8.0f;
    }

    void mouseButtonPressed(Point mousePoint, int mouseButton)
    {
        this.lastMousePoint = mousePoint;
        this.resizeMode = ResizeMode.SizeNone;
  
        if (mousePoint.x > this.layoutSize.width)
            this.resizeMode |= ResizeMode.SizeRight;
        if (mousePoint.y > this.layoutSize.height)
            this.resizeMode |= ResizeMode.SizeBottom;
    }

    void mousePositionChanged(Point mousePoint)
    {
        Point delta = mousePoint.minus(this.lastMousePoint);

        if (this.resizeMode > 0)
        {
            int x = 0, y = 0;

            if ((this.resizeMode & ResizeMode.SizeRight) == ResizeMode.SizeRight)
                x = delta.x;
            if ((this.resizeMode & ResizeMode.SizeBottom) == ResizeMode.SizeBottom)
                y = delta.y;

            this.setLayoutSize(new Size(this.layoutSize.width + x, this.layoutSize.height + y));
            
            this.lastMousePoint = mousePoint;
        }
        else
        {
            this.setLayoutMargin(this.getLayoutMargin().addLeftTopPoint(delta));

            this.measureView();
            this.layoutView(new Rect(0, 0, 0, 0));
        }
    }

    void drawView(PGraphics g)
    {
        int inset = 24;
        
        g.fill(0, 0, 0);
        g.noStroke();
        g.beginShape();
          g.vertex(inset, 0);
          g.vertex(this.layoutSize.width - inset, 0);
          
          g.vertex(this.layoutSize.width - inset - 13, 23);
          g.vertex(this.layoutSize.width - inset - 15, 25);
          g.vertex(this.layoutSize.width - inset - 18, 26);

          g.vertex(inset + 18, 26);
          g.vertex(inset + 15, 25);
          g.vertex(inset + 13, 23);
        g.endShape(CLOSE);

        if (this.hasSeparator)
        {
            g.rect(0, this.contentView.frameOrigin.y - 3, this.layoutSize.width, 3);
        }
    }

    void drawChildViews(PGraphics g)
    {
        ListIterator<View> iter = this.childViews.listIterator(0);

        while (iter.hasNext())
        {
            View childView = iter.next();

            if (childView == this.contentView)
            {
                if (this.needsRedraw())
                {
                    this.contentImage.beginDraw();
                    childView.draw(this.contentImage);
                    this.contentImage.endDraw();
                    
                    this.needsRedraw = false;
                }
                
                g.image(this.contentImage, 0, 0);
            }
            else childView.draw(g);
        }
    }  

}