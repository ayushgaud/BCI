funList = {@f1,@f2};

spmd
    labBarrier
	a{labindex}=funList{labindex}()
end
