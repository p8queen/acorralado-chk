//+------------------------------------------------------------------+
//|                                                   Acorralado.mqh |
//|                                  Copyright 2018, Gustavo Carmona |
//|                                           http://www.awtt.com.ar |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Gustavo Carmona"
#property link      "http://www.awtt.com.ar"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Acorralado
  {
private:
   string name;
   int lsNumOrder[10];
   char p;
   double deltaTips, lots, deltaStTp;
   double priceBuyStop, priceSellStop;
   double balance;
   bool botIsOpen;
   bool orderGetProfit;
   
public:
                     Acorralado(string robotName);
                    ~Acorralado();
  void               setInitialValues();
  void               setInitialOrder();                    
                   
  double             getBalance();
  bool               getBotIsOpen(){ return botIsOpen;}
  int                getTicketLastExecutedOrder(){ return lsNumOrder[p-1];}
  void               checkOPwhenTakeProfit();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Acorralado::Acorralado(string robotName)
  {
   name = robotName;
   setInitialValues();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Acorralado::~Acorralado()
  {
  }
//+------------------------------------------------------------------+
void Acorralado::setInitialValues(void){
   
   deltaTips = 40*0.0001;
   deltaStTp = 5*0.00001;
   balance = 0;
   botIsOpen = true;
   orderGetProfit = false;

   }

void Acorralado::setInitialOrder(){
   double price, st, tp;
   ArrayInitialize(lsNumOrder, -1);
   p=0;
   lots = 0.01;
   price = Ask;
   st = price - 2*deltaTips;
   tp = price + deltaTips - deltaStTp;
   lsNumOrder[p] = OrderSend("EURUSD",OP_BUY,lots,price,10,st,tp,"bot acorralado");
   p++;
  
   priceSellStop = Bid-deltaTips;
   st = priceSellStop + 2*deltaTips;
   tp = priceSellStop - deltaTips;
   lsNumOrder[p] = OrderSend("EURUSD",OP_SELLSTOP,lots+0.02,priceSellStop,10,st,tp,"bot acorralado");
   p++;
  
   price = Bid;
   st = price + 2*deltaTips;
   tp = price - deltaTips + deltaStTp;
   lsNumOrder[p] = OrderSend("EURUSD",OP_SELL,lots,price,10,st,tp,"bot acorralado");
   p++;
  
   priceBuyStop = Ask+deltaTips;
   st = priceBuyStop - 2*deltaTips;
   tp = priceBuyStop + deltaTips;
   lsNumOrder[p] = OrderSend("EURUSD",OP_BUYSTOP,lots+0.02,priceBuyStop,10,st,tp,"bot acorralado");
 
   }
 

 
 double Acorralado::getBalance(void){
   balance = 0;
   for(int z=1;z<4;z+=2){
   if(!OrderSelect(lsNumOrder[z],SELECT_BY_TICKET))
      Print("-- Error Select getBalance, Order No Open ",GetLastError());
   Print("-- getBalance, Order Open, profit, comision: ", OrderProfit(), ", ", OrderCommission());
  
   if(OrderCommission()<0){
      balance = OrderProfit()+OrderCommission()+OrderSwap();
      if(!OrderSelect(lsNumOrder[z-1],SELECT_BY_TICKET))
         Print("-- Error Select getBalance, Order No Open ",GetLastError());
      balance += OrderProfit()+OrderCommission()+OrderSwap();
      Print("--***** balance: 0-03 lots + 0.01 lots, ", balance);
      
      if(balance>=(-1)){
         if(z==1){
            //close sellstop and z-1 is buy
            OrderClose(lsNumOrder[z],0.03,Ask,10);
            OrderClose(lsNumOrder[z-1],0.01,Bid,10);
            }else{
            // z is 3, buystop and z-1 is sell
            OrderClose(lsNumOrder[z],0.03,Bid,10);
            OrderClose(lsNumOrder[z-1],0.01,Ask,10);
            }
            //start again
            setInitialOrder();
         }
     }//if ordercomission
   }//for   
   return balance;  
     
 }
 

 
 void Acorralado::checkOPwhenTakeProfit(){
      
       if(priceBuyStop - deltaStTp< Bid){
         if(!OrderDelete(lsNumOrder[1]))
            Print("Close Pending Order Error: ", GetLastError());
         //botIsOpen = false;
         }
         
       if(priceSellStop + deltaStTp > Ask){
         if(!OrderDelete(lsNumOrder[3]))
            Print("Close Pending Order Error: ", GetLastError());
         //botIsOpen = false;
         }
         
  
 }