//
// WM
//

/*

Menus
  Change calculator to scientific?
ScrollView
Drawing App
Radial Menus
Animation
2px line = draw 2 1px lines

*/

RootView screenView;
WindowView deskView;
Scheduler scheduler;

boolean needsRedraw;

void setup()
{
    size(1280, 768, P2D);
    pixelDensity(displayDensity());
    frameRate(30);
    
    try {
        Process process = Runtime.getRuntime().exec("/bin/pwd");
        OutputStream ostream = process.getOutputStream();
        InputStream istream = process.getInputStream();
        while (istream.available() > 0) {
            print((char) istream.read());
        }
    } catch (IOException e) {
        println(e);
    }

    scheduler = new Scheduler();
  
    screenView = new RootView(new Point(0, 0), new Size(width, height));
    needsRedraw = true;

    //screenView.addChildView(
    //  new View(new Point(100, 100), new Size(200, 200)).addChildView(
    //    new View(new Point(10, 10), new Size(Size.Fill, 50))
    //  )
    //);

    //screenView.addChildView(
    //  new WindowView(new Point(100, 100), new Size(200, 200))
    //);
    
    createDemo();
}

float minFrameRate, maxFrameRate, avgFrameRate;

void draw()
{
    //background(#000000);
    
    scheduler.tick(millis());

    if (screenView.needsLayout)
    {
        println("screenView.needsLayout == true");
        screenView.measureView();
        screenView.layoutView(new Rect(0, 0, width, height));
    }

//    if (needsRedraw)
    {    
        //screenView.layout(new Rect(0, 0, width, height));
    
        screenView.draw(this.g);
        
        needsRedraw = false;
    }
    
    if ((frameCount - 1) % 600 == 0)
    {
        minFrameRate = Integer.MAX_VALUE;
        maxFrameRate = Integer.MIN_VALUE;
    }

    avgFrameRate = avgFrameRate * 0.99 + frameRate * 0.01;
    minFrameRate = min(minFrameRate, frameRate);
    maxFrameRate = max(maxFrameRate, frameRate);

    fill(0);
    rect(0, 0, 100, 70);
    fill(255);
    text(String.format("%f", avgFrameRate), 0, 05, 100, 20);
    text(String.format("%f", minFrameRate), 0, 25, 100, 20);
    text(String.format("%f", maxFrameRate), 0, 45, 100, 20);
}

void mousePressed()
{
    Event mousePressedEvent = new MouseEvent(MouseEvent.ButtonPressed, new Point(mouseX, mouseY), mouseButton, 0);
    screenView.sendEvent(mousePressedEvent);
    
    //screenView.mouseButtonPressed(new Point(mouseX, mouseY), mouseButton);

    needsRedraw = true;
}

void mouseDragged()
{
    screenView.sendEvent(new MouseEvent(MouseEvent.PositionChanged, new Point(mouseX, mouseY), mouseButton, 0));

    //screenView.mousePositionChanged(new Point(mouseX, mouseY));

    needsRedraw = true;
}

void mouseReleased()
{
    screenView.sendEvent(new MouseEvent(MouseEvent.ButtonReleased, new Point(mouseX, mouseY), mouseButton, 0));

    //screenView.mouseButtonReleased(new Point(mouseX, mouseY), mouseButton);

    needsRedraw = true;
}

void mouseWheel(processing.event.MouseEvent mouseEvent)
{
    screenView.sendEvent(new MouseEvent(MouseEvent.ScrollChanged, new Point(mouseX, mouseY), mouseButton, mouseEvent.getCount()));

    needsRedraw = true;
}

void createDemo()
{
    ButtonView buttonView;
    LabelView labelView;
    ImageView imageView;
    WindowView windowView;

    screenView.addChildView(
      new WindowView(new Point(500, 400), new Size(400, 300),
        new ImageView(new Point(0, 0), new Size(400, 300))
            .setImage(loadImage("max_headroom.jpg")),
      WindowView.Separator)
    );

    screenView.addChildView(
        new WindowView(new Point(100, 100), new Size(280, 180)).addChildViews(
            new LabelView(new Point((280 - 250) / 2, 10), new Size(250, 100))
                .setText("Welcome to Processing WM\nCreated by Mike Austin"),
            new ButtonView(new Point((280 - 100) / 2, 118), new Size(100, 26))
                .setTitleText("Click Me")
                .setStrokePosition(View.StrokeInside)
                .setClickedAction(new Action<ButtonView>() {
                    public void invoke(ButtonView buttonView)
                    {
                        println("Button pressed!");
                    }
                })
      )
    );

    //deskView.clickToFront = false;
    //deskView.backgrColor = null;
    //deskView.removeChildView(deskView.contentView);

    screenView.addChildView(
      windowView = new WindowView(new Point(100, 400), new Size(200, 296),
                                  new CalculatorView(new Point(), new Size()), WindowView.NoSeparator)
    );

    windowView.setFocused();
    
    screenView.addChildView(
      new WindowView(new Point(500, 100), new Size(200, 226),
                     new ClockView(new Point(), new Size(200, 200)), WindowView.NoSeparator)
    );

    screenView.addChildView(
      new WindowView(new Point(800, 100), new Size(200, 230),
                     new CubeView(new Point(), new Size(200, 200)), WindowView.NoSeparator, P3D)
    );
}