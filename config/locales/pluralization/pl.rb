key = lambda{|n| n==1 ? :one : n%10>=2 && n%10<=4 && (n%100<10 || n%100>=20) ? :few : :other}
{:pl => {:i18n => {:plural => {:keys => [:one, :few, :other], :rule => key}}}}