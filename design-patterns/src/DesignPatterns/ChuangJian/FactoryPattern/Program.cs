namespace FactoryPattern
{
    internal class Program
    {
        private static void Main(string[] args)
        {
            // 调用工厂模式创建实例类型
            CashSuper csuper = CashFactory.createCashAccept("正常收费");
            var totalPrices = csuper.acceptCash(200);
            Console.WriteLine(totalPrices.ToString());
        }
    }
}