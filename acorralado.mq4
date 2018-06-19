//+------------------------------------------------------------------+
//|                                               Acorralado-chk.mq4 |
//|                                  Copyright 2018, Gustavo Carmona |
//|                                      awwthttps://www.awtt.com.ar |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|el usuario hace una orden de compra o venta, con las lineas 
//| Ema separadas. Luego el robot va comprando o vendiendo o cerrando
//| en los cruces. Usa periodos H1 y las EMA de 10 y 50. 
//+------------------------------------------------------------------+

//+
#property copyright "Copyright 2018, Gustavo Carmona"
#property link      "https://www.awtt.com.ar"
#property version   "1.00"
#property strict
#include "acorralado.mqh"

Acorralado bot("bot"), tob("tob");
double profitBot, profitTob;
int lastOP;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
  bot.setInitialOrder();
  

  return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){

   bot.checkOPwhenTakeProfit();
   bot.getBalance();
   //if last order executed
   /*
   profitTob = 0;
   profitBot = 0;
   bot.setPendingOrder();
   tob.setPendingOrder();
   profitBot = bot.getBalance();
   profitTob = tob.getBalance();
   Comment("Balance bot= ",profitBot, ", balance tob= ", profitTob);
   bot.closePendingOrder();
   tob.closePendingOrder();

   if(!bot.getBotIsOpen()){
      if(!OrderSelect(bot.getTicketLastExecutedOrder(),SELECT_BY_TICKET,MODE_HISTORY))
         Comment("Error Select Order: ", GetLastError());
      lastOP = OrderType();
      bot.setInitialValues();
      bot.setInitialOrder((lastOP+1)%2);
      }
   
   if(!tob.getBotIsOpen()){
      if(!OrderSelect(tob.getTicketLastExecutedOrder(),SELECT_BY_TICKET,MODE_HISTORY))
         Comment("Error Select Order: ", GetLastError());
      lastOP = OrderType();
      tob.setInitialValues();
      tob.setInitialOrder((lastOP+1)%2);
      }
     */ 
}      
      
    