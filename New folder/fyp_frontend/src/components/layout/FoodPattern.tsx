import { Pizza, Beef, Coffee, IceCream, Utensils, Apple, Sandwich, Cake } from 'lucide-react';

const FoodPattern: React.FC = () => {
  const icons = [
    <Pizza size={24} />, <Beef size={24} />, <Coffee size={24} />, 
    <IceCream size={24} />, <Utensils size={24} />, <Apple size={24} />, 
    <Sandwich size={24} />, <Cake size={24} />
  ];

  return (
    <div className="absolute inset-0 z-0 opacity-10 overflow-hidden pointer-events-none select-none mix-blend-overlay">
      <div className="flex flex-wrap gap-12 w-[150%] h-[150%] -rotate-12 -translate-x-10 -translate-y-10">
        {Array.from({ length: 150 }).map((_, i) => (
          <div key={i} className="text-white transform transition-transform duration-1000">
            {icons[i % icons.length]}
          </div>
        ))}
      </div>
    </div>
  );
};

export default FoodPattern;
