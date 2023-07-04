using System;
using HashiCorp.Cdktf;

namespace EX7.Modularization.CSharp
{
    class Program
    {
        public static void Main(string[] args)
        {
            App app = new App();
            new EX7Stack(new TerraformStack(app, "azurerm"), "local");
            app.Synth();
            Console.WriteLine("App synth complete");
        }
    }
}