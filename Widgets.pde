//
// Widgets
//

class ResizeMode {
  
    public final static int SizeNone   = 0;
    public final static int SizeLeft   = 1 << 0;
    public final static int SizeTop    = 1 << 1;
    public final static int SizeRight  = 1 << 2;
    public final static int SizeBottom = 1 << 3;
  
};

//
// ButtonView
//

class ButtonView extends View {

    private Color normalColor = Color.White,
                  pressedColor = Color.Black;
    private Color normalTextColor = Color.Black,
                  pressedTextColor = Color.White;
 
    private LabelView titleLabelView;
    private Action<ButtonView> clickedAction;
    private boolean insideBounds;
  
    ButtonView(Point origin, Size size)
    {
        super(origin, size);
        
        initialize();
        
        this.addChildView(this.titleLabelView = new LabelView(new Point(0, 0), size));
    }

    ButtonView(Point origin, Size size, String title)
    {
        super(origin, size);
        
        initialize();
        
        this.addChildView(this.titleLabelView = new LabelView(new Point(0, 0), size));
        
        this.setTitleText(title);
    }

    void initialize()
    {
        this.acceptsEvents = true;
                
        this.setFillColor(this.normalColor);
        this.cornerRadius = 5;
        this.strokePosition  = StrokeInside;
        this.strokeWidth = 3;
    }

    ButtonView setStrokePosition(int strokePosition)
    {
        super.setStrokePosition(strokePosition);
        
        return this;
    }

    ButtonView setTitleText(String text)
    {
        this.titleLabelView.text = text;
        
        return this;
    }

    String getTitleText()
    {
        return this.titleLabelView.text;
    }

    ButtonView setClickedAction(Action<ButtonView> clickedAction)
    {
        this.clickedAction = clickedAction;
        
        return this;
    }

    ButtonView setClickedMethod(final Object target, final String methodName)
    {
        this.setClickedAction(new Action<ButtonView>() {
            public void invoke(ButtonView buttonView) {
                try {
                    target.getClass().getMethod(methodName, ButtonView.class).invoke(target, buttonView);
                } catch (NoSuchMethodException e) {
                    println(e);
                } catch (IllegalAccessException e) {
                    println(e);
                } catch (InvocationTargetException e) {
                    println(e);
                }
            }
        });
        
        return this;
    }

    void mouseButtonPressed(Point mousePoint, int mouseButton)
    {
        this.setFillColor(this.pressedColor);
        this.titleLabelView.setTextColor(this.pressedTextColor);
        
        getWindowView().needsRedraw(true);
    }

    void mousePositionChanged(Point mousePoint)
    {
        boolean containsPoint = this.containsPoint(mousePoint);
        
        if (this.containsPoint(mousePoint))
        {
            this.setFillColor(this.pressedColor);
            this.titleLabelView.setTextColor(this.pressedTextColor);
        }
        else
        {
            this.setFillColor(this.normalColor);
            this.titleLabelView.setTextColor(this.normalTextColor);
        }

        if (this.insideBounds != containsPoint)
        {
            this.insideBounds = containsPoint;
            
            getWindowView().needsRedraw(true);
        }
    }

    void mouseButtonReleased(Point mousePoint, int mouseButton)
    {
        if (this.containsPoint(mousePoint))
        {
            if (this.clickedAction != null)
            {
                this.clickedAction.invoke(this);
            }
        }
        
        this.setFillColor(this.normalColor);
        this.titleLabelView.setTextColor(this.normalTextColor);

        getWindowView().needsRedraw(true);
    }

    //View hitTestForEvent(MouseEvent mouseEvent, Point mousePoint)
    //{
    //    View targetView = super.hitTestForEvent(mousePoint);
        
    //    if (mouseEvent.eventType == MouseEvent.ScrollChanged)
    //    {
    //        if (targetView == null || targetView == this) return null;
    //    }
        
    //    return targetView;
    //}

}

class LabelView extends View {

    private String text = "Hello, world!";
    private Color  textColor = Color.Black;
    private PFont  font = createFont("Helvetica-Bold", 14);
    
    private int    fontSize = 14;
    private int    align = Align.Center;

    LabelView(Point origin, Size size)
    {
        super(origin, size);

        initialize();
    }

    LabelView(Point origin, Size size, String text)
    {
        super(origin, size);

        initialize();        
        
        this.setText(text);
    }

    void initialize()
    {
        this.setFillColor(null);
        this.setStrokeColor(null);
    }

    View hitTestForEvent(MouseEvent event, Point mousePoint)
    {
        return null;
    }

    void setFont(PFont font)
    {
        this.font = font;
        this.fontSize = font.getDefaultSize();
    }

    void setFont(PFont font, int fontSize)
    {
        this.font = font;
        this.fontSize = fontSize;
    }

    LabelView setText(String text)
    {
        this.text = text;
        
        return this;
    }

    String getText()
    {
        return this.text;
    }

    void setTextColor(Color textColor)
    {
        this.textColor = textColor;
    }

    void setTextAlignment(int align)
    {
        this.align = align;
    }

    void drawView(PGraphics g)
    {
        g.textFont(this.font, this.fontSize);
        g.fill(this.textColor.getRed(), this.textColor.getGreen(), this.textColor.getBlue(), this.textColor.getAlpha());
        g.textAlign(this.align, CENTER);
        
        g.text(this.text, 0, 0, this.layoutSize.width, this.layoutSize.height);
    }

}

class ImageView extends View {

    protected PImage image;
  
    ImageView(Point origin, Size size)
    {
        super(origin, size);

        this.strokeColor = null;
    }

    ImageView setImage(PImage image)
    {
        this.image = image;
        
        this.image.filter(GRAY);
        this.image.filter(POSTERIZE, 16);
        
        return this;
    }

    void drawView(PGraphics g)
    {
        if (this.image != null)
        {
            g.image(this.image, 0, 0, this.layoutSize.width, this.layoutSize.height);
        }
    }

}

class ScrollView extends View {

    protected View contentView;
  
    ScrollView(Point origin, Size size)
    {
        super(origin, size);

        this.acceptsEvents = true;
        
        super.addChildView(
          this.contentView = new View(new Point(0, 0), new Size(size.width, size.height))
        );
    }

    View addChildView(View childView)
    {
        this.contentView.addChildView(childView);
        
        return this;
    }

    //View hitTestForEvent(MouseEvent mouseEvent, Point mousePoint)
    //{
    //    //View targetView = super.hitTestForEvent(mouseEvent, mousePoint);
    //    View targetView = super.hitTestForEvent(mousePoint);

    //    if (mouseEvent.eventType == MouseEvent.ScrollChanged)
    //    {
    //        if (targetView == null || targetView == this) return this;
    //    }
    
    //    return targetView;
    //}
    
    //void mouseScrollChanged(int mouseScroll)
    //{
    //    super.mouseScrollChanged(mouseScroll);
      
    //    Point contentOffset = this.getContentOffset();
    //    println(mouseScroll);
    //    this.setContentOffset(new Point(0, contentOffset.y - mouseScroll * 2));
    //}

    //void setContentOffset(Point point)
    //{
//  //      this.contentView.setFrameOrigin(point);
    //}

    //Point getContentOffset()
    //{
//  //      return this.contentView.getFrameOrigin();
    //}

}