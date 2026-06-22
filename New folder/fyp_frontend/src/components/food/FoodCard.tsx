import React from 'react';
import { Star, Plus, Heart } from 'lucide-react';
import { motion } from 'framer-motion';
import { useNavigate } from 'react-router-dom';

interface FoodCardProps {
  item: any;
  onAdd?: (item: any) => void;
}

const FoodCard: React.FC<FoodCardProps> = ({ item, onAdd }) => {
  const navigate = useNavigate();

  return (
    <motion.div 
      whileHover={{ y: -4 }}
      className="bg-white rounded-[2rem] overflow-hidden border border-slate-50 shadow-sm hover:shadow-xl transition-all group flex flex-col h-full cursor-pointer"
      onClick={() => navigate(`/food/${item.id}`)}
    >
      {/* Image Container */}
      <div className="relative aspect-[4/3] overflow-hidden bg-slate-50">
        <img 
          src={item.image} 
          alt={item.title} 
          className="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700" 
        />
        <div className="absolute top-3 right-3 flex flex-col gap-2">
           <button 
             onClick={(e) => { e.stopPropagation(); }}
             className="bg-white/90 backdrop-blur-md p-2 rounded-xl text-slate-300 hover:text-red-500 transition-colors shadow-sm"
           >
              <Heart size={14} />
           </button>
        </div>
        
        {item.rating && (
          <div className="absolute bottom-3 left-3 bg-slate-900/80 backdrop-blur-md px-3 py-1.5 rounded-full flex items-center gap-1.5 border border-white/10">
            <Star size={10} className="text-amber-400 fill-current" />
            <span className="text-[9px] font-black text-white">{item.rating}</span>
          </div>
        )}
      </div>

      <div className="p-5 flex flex-col flex-grow">
        <div className="flex-grow">
          <h3 className="text-sm font-black text-slate-900 uppercase tracking-tight mb-1 group-hover:text-primary-600 transition-colors leading-tight line-clamp-1">{item.title}</h3>
          <p className="text-slate-400 text-[9px] font-bold uppercase tracking-widest line-clamp-2 mb-4 leading-relaxed opacity-60">{item.description}</p>
        </div>

        <div className="flex items-center justify-between pt-4 border-t border-slate-50">
          <div className="flex flex-col">
             <span className="text-[8px] font-black text-slate-300 uppercase tracking-widest leading-none mb-1">Price</span>
             <span className="text-xl font-black text-slate-900 tracking-tighter">${item.price.toFixed(2)}</span>
          </div>
          <button 
            onClick={(e) => {
              e.stopPropagation();
              onAdd?.(item);
            }}
            className="w-10 h-10 bg-slate-900 text-white rounded-xl flex items-center justify-center hover:bg-primary-500 transition-all shadow-md active:scale-90"
          >
            <Plus size={18} />
          </button>
        </div>
      </div>
    </motion.div>
  );
};

export default FoodCard;
