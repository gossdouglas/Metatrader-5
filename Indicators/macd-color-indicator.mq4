/*

*********************************************************************
          
                            MACD Color
                   Copyright © 2006  Akuma99
                  http://www.beginnertrader.com/  

       For help on this indicator, tutorials and information 
               visit http://www.beginnertrader.com/
                  
*********************************************************************

*/

#property  copyright ""
#property  link      ""

#property  indicator_separate_window
#property  indicator_buffers 6
#property  indicator_color1  Red
#property  indicator_color2  LimeGreen
#property  indicator_color3  Red
#property  indicator_color4  LimeGreen
#property  indicator_color5  Black  
#property  indicator_color6  Black

extern int FastEMA=12;
extern int SlowEMA=26;
extern int SignalSMA=9;

double     ind_buffer1[];
double     ind_buffer2[];
double     ind_buffer1b[];
double     ind_buffer2b[];
double     ind_buffer3[];
double     ind_buffer4[];

double     b[999999];

int init() {

   //SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID,2,indicator_color1);
   PlotIndexSetInteger(0,DRAW_HISTOGRAM,STYLE_SOLID,2,indicator_color1);
   SetIndexStyle(1,DRAW_HISTOGRAM,STYLE_SOLID,2,indicator_color2);
   SetIndexStyle(2,DRAW_HISTOGRAM,STYLE_SOLID,2,indicator_color3);
   SetIndexStyle(3,DRAW_HISTOGRAM,STYLE_SOLID,2,indicator_color4);
   SetIndexStyle(4,DRAW_LINE,EMPTY,1,indicator_color5);
   SetIndexStyle(5,DRAW_LINE,EMPTY,1,indicator_color6);
   SetIndexBuffer(0,ind_buffer1);
   SetIndexBuffer(1,ind_buffer2);
   SetIndexBuffer(2,ind_buffer1b);
   SetIndexBuffer(3,ind_buffer2b);
   SetIndexBuffer(4,ind_buffer3);
   SetIndexBuffer(5,ind_buffer4);
   
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS)+1);
   
   EventSetTimer(60); 
   
   return(0);

}

//| Expert deinitialization function                                 | 
//+------------------------------------------------------------------+ 
void OnDeinit(const int reason) 
  { 
//--- destroy the timer after completing the work 
   EventKillTimer(); 
  
  } 

int start(){
   
   int limit;
   int counted_bars=IndicatorCounted();

   if(counted_bars<0) return(-1);

   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;

   for(int i=limit; i>=0; i--) {
      
      b[i] = iMA(NULL,0,FastEMA,0,MODE_EMA,PRICE_CLOSE,i)-iMA(NULL,0,SlowEMA,0,MODE_EMA,PRICE_CLOSE,i);
      ind_buffer1[i]=iMA(NULL,0,FastEMA,0,MODE_EMA,PRICE_CLOSE,i)-iMA(NULL,0,SlowEMA,0,MODE_EMA,PRICE_CLOSE,i);
      
      clearBuffers(i);
      
      if (b[i] < 0 ) {
         if (b[i] > b[i+1]) {
            ind_buffer1[i] = b[i];
            ind_buffer1b[i] = 0;
         } else if (b[i] < b[i+1]) {
            ind_buffer1b[i] = b[i];
            ind_buffer1[i] = 0;
         }
      } else if (b[i] > 0) {
          if (b[i] < b[i+1]) {
            ind_buffer2[i] = b[i];
            ind_buffer2b[i] = 0;
         } else if (b[i] > b[i+1]) {
            ind_buffer2b[i] = b[i];
            ind_buffer2[i] = 0;
         }
      }
      
      ind_buffer3[i]=iMA(NULL,0,FastEMA,0,MODE_EMA,PRICE_CLOSE,i)-iMA(NULL,0,SlowEMA,0,MODE_EMA,PRICE_CLOSE,i);
      
   }
   
   for(i=0; i<limit; i++) {
         ind_buffer4[i]=iMAOnArray(ind_buffer3,Bars,SignalSMA,0,MODE_SMA,i);
      }

   return(0);
   
}

void clearBuffers (int i) {
         
      ind_buffer1[i] = NULL;
      ind_buffer1b[i] = NULL;
      ind_buffer2[i] = NULL;
      ind_buffer2b[i] = NULL;
         
}

void OnTimer()
  {
    Print("M1 TIMER KICKED OFF");
  }