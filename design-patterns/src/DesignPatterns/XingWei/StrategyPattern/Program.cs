namespace StrategyPattern
{
    internal class Program
    {
        static void Main(string[] args)
        {
            //采用策略模式
            CashContext csuper = new CashContext("打8折");
            var totalPrices = csuper.GetResult(200);
            Console.WriteLine(totalPrices);
        }
    }
}