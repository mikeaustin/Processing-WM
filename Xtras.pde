//
// Xtras
//

import java.lang.reflect.*;

class ShadowView extends View {
    ShadowView(Point origin, Size size)
    {
        super(origin, size);
    }
}

class ClockView extends View {

    float angle = 0;
    int   lastMillis = 0;

    private PFont  font = createFont("Serif", 24);

    ClockView(Point origin, Size size)
    {
        super(origin, size);
    
        scheduler.addTimer(new Timer(1000, new Action<Long>()
        {
            void invoke(Long millis)
            {
              ClockView.this.angle = radians(second() * (360 / 60.0));
      
              ClockView.this.getWindowView().needsRedraw(true);
            }
        }));
    }

    PVector pointForAngle(float angle, float radius)
    {
        return new PVector(sin(angle) * radius, -cos(angle) * radius);
    }

    void drawView(PGraphics g)
    {
        PVector centerPoint = new PVector(this.layoutSize.width / 2, this.layoutSize.height / 2);
        Size clockSize = new Size(this.layoutSize.width - 20, this.layoutSize.height - 20);
  
        final String hours[] = { "3", "6", "9", "12" };
  
        g.fill(63, 63, 63);
        for (int a = 0; a < 360; a += 360.0 / 12)
        {
            float angle = radians(a);
            
            float x = centerPoint.x + cos(angle) * (clockSize.width / 2 - 20);
            float y = centerPoint.y + sin(angle) * (clockSize.height / 2 - 20);

            if (a % 90 == 0)
            {
                g.textFont(this.font);
                g.textAlign(CENTER, CENTER);

                //g.text(hours[a / (360 / 4)], x - 20, y - 15, 40, 30);
                g.ellipse(x, y, 7, 7);
            }
            else
                g.ellipse(x, y, 3, 3);
        }  
  
        float hourAngle   = radians(hour() * (360.0 / 12) + minute() * (360.0 / 60 / 12) + second() * (360.0 / 60 / 60 / 12));
        float minuteAngle = radians(minute() * (360.0 / 60) + second() * (360.0 / 60 / 60));
        float secondAngle = radians(second() * (360.0 / 60));
  
        PVector hourMidPoint   = this.pointForAngle(hourAngle, -0.0), 
                hourEndPoint   = this.pointForAngle(hourAngle, clockSize.width / 3 - 20);
        PVector minuteMidPoint = this.pointForAngle(minuteAngle, -0.0), 
                minuteEndPoint = this.pointForAngle(minuteAngle, clockSize.width / 2 - 20);
        PVector secondMidPoint = this.pointForAngle(secondAngle, -15), 
                secondEndPoint = this.pointForAngle(secondAngle, clockSize.width / 2 - 20);
  
        g.stroke(63, 63, 63);
        g.noFill();
  
        g.strokeWeight(3);
        g.ellipse(centerPoint.x, centerPoint.y, clockSize.width - 3, clockSize.height - 3);
  
        g.strokeWeight(10);
        g.line(centerPoint.x + hourMidPoint.x, centerPoint.y + hourMidPoint.y, centerPoint.x + hourEndPoint.x, centerPoint.y + hourEndPoint.y);
  
        //g.strokeWeight(5);
        g.line(centerPoint.x + minuteMidPoint.x, centerPoint.y + minuteMidPoint.y, centerPoint.x + minuteEndPoint.x, centerPoint.y + minuteEndPoint.y);
  
        g.stroke(Color.Gray.getRed());
        g.strokeWeight(2);
        g.line(centerPoint.x + secondMidPoint.x, centerPoint.y + secondMidPoint.y, centerPoint.x + secondEndPoint.x, centerPoint.y + secondEndPoint.y);
  
        g.fill(255);
        g.noStroke();
        g.ellipse(centerPoint.x, centerPoint.y, 3, 3);
    }

}

class CubeView extends View {

  CubeView(Point origin, Size size)
  {
    super(origin, size);

    scheduler.addTimer(new Timer(1000 / 60, new Action<Long>()
    {
      void invoke(Long millis)
      {
        CubeView.this.getWindowView().needsRedraw(true);
      }
    }
    ));
  }

  void drawView(PGraphics g)
  {
    PVector centerPoint = new PVector(this.layoutSize.width / 2, this.layoutSize.height / 2);

    g.perspective(PI / 3.0, 1, 10, 10000);

    g.translate(centerPoint.x, centerPoint.y);
    g.noStroke();
    g.lights();
    g.translate(0, -10, 100);
    g.rotateX(-0.5);
    g.rotateY(millis() / 2000.0);
    g.box(50);
  }
}

interface Operator {

  public int invoke(int left, int right);
}

class CalculatorView extends View {

  private LabelView displayLabelView;
  private String    lastOperator;
  private boolean   resetDisplay;
  private int       currentValue;

  private HashMap<String, Operator> operators = new HashMap<String, Operator>() {
    {
      put("+", new Operator() { 
        int invoke(int a, int b) { 
          return a + b;
        }
      }
      );
      put("−", new Operator() { 
        int invoke(int a, int b) { 
          return a - b;
        }
      }
      );
      put("×", new Operator() { 
        int invoke(int a, int b) { 
          return a * b;
        }
      }
      );
      put("÷", new Operator() { 
        int invoke(int a, int b) { 
          return a / b;
        }
      }
      );
    }
  };

  CalculatorView(Point origin, Size size)
  {
    super(origin, size);

    int top = 60;

    View displayView;

    this.addChildViews(
      //new ButtonView(new Point(220 + left, 10 + 2), new Size(30, 35), ">"),
      this.displayLabelView = new LabelView(new Point(15, 10), new Size(170, 40)), 
      displayView = new View(new Point(10, 10), new Size(180, 40)), 

      new ButtonView(new Point(10, 60), new Size(40, 35), "M"), 
      new ButtonView(new Point(55, 60), new Size(40, 35), "×").setClickedMethod(this, "operatorPressed"), 
      new ButtonView(new Point(100, 60), new Size(40, 35), "÷").setClickedMethod(this, "operatorPressed"), 
      new ButtonView(new Point(150, 60), new Size(40, 35), "C"), 

      new ButtonView(new Point(10, top + 45), new Size(40, 35), "7").setClickedMethod(this, "numberPressed"), 
      new ButtonView(new Point(55, top + 45), new Size(40, 35), "8").setClickedMethod(this, "numberPressed"), 
      new ButtonView(new Point(100, top + 45), new Size(40, 35), "9").setClickedMethod(this, "numberPressed"), 
      new ButtonView(new Point(150, top + 45), new Size(40, 35), "+").setClickedMethod(this, "operatorPressed"), 

      new ButtonView(new Point(10, top + 85), new Size(40, 35), "4").setClickedMethod(this, "numberPressed"), 
      new ButtonView(new Point(55, top + 85), new Size(40, 35), "5").setClickedMethod(this, "numberPressed"), 
      new ButtonView(new Point(100, top + 85), new Size(40, 35), "6").setClickedMethod(this, "numberPressed"), 
      new ButtonView(new Point(150, top + 85), new Size(40, 35), "−").setClickedMethod(this, "operatorPressed"), 

      new ButtonView(new Point(10, top + 125), new Size(40, 35), "1").setClickedMethod(this, "numberPressed"), 
      new ButtonView(new Point(55, top + 125), new Size(40, 35), "2").setClickedMethod(this, "numberPressed"), 
      new ButtonView(new Point(100, top + 125), new Size(40, 35), "3").setClickedMethod(this, "numberPressed"), 
      new ButtonView(new Point(150, top + 125), new Size(40, 75), "=").setClickedMethod(this, "equalsPressed"), 

      new ButtonView(new Point(10, top + 165), new Size(85, 35), "0").setClickedMethod(this, "numberPressed"), 
      new ButtonView(new Point(100, top + 165), new Size(40, 35), ".")
      );

    displayView.strokePosition = View.StrokeInside;
    displayView.setFillColor(null);

    this.displayLabelView.setFont(loadFont("LED.vlw"), 32);
    this.displayLabelView.setTextAlignment(Align.Right);
    this.displayLabelView.setText("0");
    this.resetDisplay = true;
  }

  void numberPressed(ButtonView buttonView)
  {
    String displayText = this.displayLabelView.getText();

    if (this.resetDisplay)
    {
      this.displayLabelView.setText(buttonView.getTitleText());

      this.resetDisplay = false;
    } else this.displayLabelView.setText(displayText + buttonView.getTitleText());
  }

  void operatorPressed(ButtonView buttonView)
  {
    int displayValue = Integer.parseInt(this.displayLabelView.getText());

    if (this.lastOperator != null)
    {
      this.currentValue = this.operators.get(this.lastOperator).invoke(this.currentValue, displayValue);
    } else this.currentValue = displayValue;

    this.lastOperator = buttonView.getTitleText(); 
    this.resetDisplay = true;
  }

  void equalsPressed(ButtonView buttonView)
  {
    if (this.lastOperator != null)
    {
      int displayValue = Integer.parseInt(this.displayLabelView.getText());

      this.currentValue = this.operators.get(this.lastOperator).invoke(this.currentValue, displayValue);
    }

    this.displayLabelView.setText(String.format("%d", this.currentValue));
    this.lastOperator = null;
    this.resetDisplay = true;
  }
}