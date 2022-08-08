namespace DecoratorPattern
{
    //Person类相当于“ConcreteComponen”
    class Person
    {
        public Person() { }

        private string name;
        public Person(string name)
        {
            this.name = name;
        }
        public virtual void Show()
        {
            Console.WriteLine($"装扮的{name}");
        }
    }
    //服饰类（Decorator）
    class Finery : Person
    {
        protected Person component;

        //打扮
        public void Decorate(Person component)
        {
            this.component = component;
        }
        public override void Show()
        {
            if (component != null)
            {
                component.Show();
            }
        }
    }

    //具体服饰类（ConcreteDecorator）
    class TShirts : Finery
    {
        public override void Show()
        {
            Console.Write("大T恤");
            base.Show();
        }
    }

    class BigTrouser : Finery
    {
        public override void Show()
        {
            Console.Write("垮裤");
            base.Show();
        }
    }

    internal class Program
    {
        static void Main(string[] args)
        {
            Person xc = new Person("小菜");
            Console.WriteLine("第一种装扮：");

            BigTrouser kk = new BigTrouser();
            TShirts dtx = new TShirts();
            //装饰过程
            kk.Decorate(xc);
            dtx.Decorate(kk);
            dtx.Show();
           
        }
    }
}