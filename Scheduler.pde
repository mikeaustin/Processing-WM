//
// Scheduler
//

class Timer {

    long timerInterval;
    long timerTimeout;
    
    Action<Long> timerAction;
  
    Timer(long timerInterval, Action<Long> timerAction)
    {
        this.timerInterval = timerInterval;
        this.timerTimeout = millis() + timerInterval;
        this.timerAction = timerAction;
    }
        
}

//
//
//

class Scheduler {
  
    ArrayList<Timer> activeTimers;

    Scheduler()
    {
        this.activeTimers = new ArrayList<Timer>();
    }
  
    void addTimer(Timer timer)
    {
        this.activeTimers.add(timer);
    }

    void tick(long millis)
    {
        ListIterator<Timer> iter = this.activeTimers.listIterator(0);

        while (iter.hasNext())
        {
            Timer timer = iter.next();
            
            if (millis >= timer.timerTimeout)
            {
                timer.timerAction.invoke(millis);
                
                timer.timerTimeout += timer.timerInterval;
            }
        }
    }
  
}