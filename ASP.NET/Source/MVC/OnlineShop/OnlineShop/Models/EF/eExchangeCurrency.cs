﻿using OnlineShop.Models.General;

namespace OnlineShop.Models.EF
{
    public class eExchangeCurrency : Master
    {
        public int IDCurrentCurrency { get; set; }
        public string CurrentCurrency { get; set; }
        public int IDExchangeCurrency { get; set; }
        public string ExchangeCurrency { get; set; }
        public decimal ExchangeValue { get; set; }
    }
}
