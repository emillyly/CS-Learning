/**
 Emilly Ly
 111097939
 CSE 214 (Assignment #3)
 */
package products;

/**
 * TODO: The 'Laptop' object should be comparable.
 *
 * @author Ritwik Banerjee
 */
public class Laptop implements Comparable<Laptop> {
    
    private String brand;
    private double processorSpeed;
    private int    ram;
    private int    price;
    private double screenSize;
    
    private Laptop(LaptopBuilder laptopBuilder) {
        this.brand = laptopBuilder.brand;
        this.processorSpeed = laptopBuilder.processorSpeed;
        this.ram = laptopBuilder.ram;
        this.price = laptopBuilder.price;
        this.screenSize = laptopBuilder.screenSize;
    }
    
    public String getBrand() {
        return brand;
    }
    
    public double getProcessorSpeed() {
        return processorSpeed;
    }
    
    public int getRam() {
        return ram;
    }
    
    public int getPrice() {
        return price;
    }
    
    public double getScreenSize() {
        return screenSize;
    }

    @Override
    public int compareTo(Laptop L) {
        if(this.getPrice() == L.getPrice())
            return 0;
        return this.getPrice() < L.getPrice() ? 1 : -1;
    }

    private static class LaptopBuilder {
        private String brand;
        private double processorSpeed;
        private int    ram;
        private int    price;
        private double screenSize;
        
        LaptopBuilder withBrand(String brand) {
            this.brand = brand;
            return this;
        }
        
        LaptopBuilder withProcessorSpeed(double processorSpeed) {
            this.processorSpeed = processorSpeed;
            return this;
        }
        
        LaptopBuilder withMemory(int ram) {
            this.ram = ram;
            return this;
        }
        
        LaptopBuilder withPrice(int price) {
            this.price = price;
            return this;
        }
        
        LaptopBuilder withScreenSize(double screenSize) {
            this.screenSize = screenSize;
            return this;
        }
        
        Laptop build() {
            return new Laptop(this);
        }
    }
    
    public static Laptop fromString(String s) {
        if (s.isEmpty())
            return null;
        String[]      aspects = s.split(",");
        LaptopBuilder builder = new LaptopBuilder();
        
        try {
            builder.withBrand(aspects[0].toLowerCase());
            builder.withProcessorSpeed(Double.parseDouble(aspects[1]));
            builder.withMemory(Integer.parseInt(aspects[2]));
            builder.withPrice(Integer.parseInt(aspects[3]));
            builder.withScreenSize(Double.parseDouble(aspects[4]));
        } catch (Exception e) {
            System.out.println("Invalid input line.");
        }
        
        return builder.build();
    }
    
    @Override
    public String toString() {
        return "products.Laptop{" + "brand='" + brand + '\'' +
               ", processorSpeed=" + processorSpeed +
               ", ram=" + ram +
               ", price=" + price +
               ", screenSize=" + screenSize +
               '}';
    }
}
