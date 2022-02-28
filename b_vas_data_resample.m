[sub_name, path_n] = uigetfile('*.csv','multiselect','on');
% load([path_n,sub_name]);

Fs = 10;

for iii=1:length(sub_name)
    T = readtable([path_n,sub_name{iii}]);                                  %{iii}
    all_data = table2array(T);
    time = seconds(all_data(:,1));
    TT1 = timetable(time,all_data(:,2:end));
    TT2 = timetable2table(retime(TT1,'regular','pchip','SampleRate',Fs*10)); %10 { 'pchip'  'linear'
    All_data = table2array(TT2(:,2:end));
    
%     All_data1 = All_data;
%     for kk = 1:length(All_data)
%         if All_data(kk,8)>180
%             All_data1(kk,8) = All_data(kk,8)-360;
%         else
%              All_data1(kk,8) = All_data(kk,8);
%         end
%         
%         if All_data(kk,9)>180
%             All_data1(kk,9) = All_data(kk,9)-360;
%             else
%              All_data1(kk,9) = All_data(kk,9);
%         end
%         
%         if All_data(kk,10)>180
%             All_data1(kk,10) = All_data(kk,10)-360;
%             else
%              All_data1(kk,10) = All_data(kk,10);
%         end
%     end
    
    Fss = Fs*10;
    Time = [];
    Time = 3/Fss/2:1/Fss:length(All_data)/Fss;
    
    Q = unwrap(All_data(:,8:10),[],1);
    D = smoothdata([All_data(:,1:7),Q],'movmean',20);    %'SamplePoints', table2array(TT2(:,1))
    
    speed = diff(D,1,1)*Fss;
%     speed1 = diff(All_data1(:,1:10),1,1)*Fs;
    
%     speed3 = [speed(:,1:7),filloutliers((speed1(:,8:10)+speed(:,8:10))/2,'makima','movmean',20)];
%     speed3 = [speed(:,1:7),filloutliers((speed1(:,8:10)+speed(:,8:10))/2,'makima','percentiles',[5 95])];

    time_ave = seconds(Time)';
    TT3 = timetable(time_ave,speed);
    TT4 = timetable2table(retime(TT3,'regular','pchip','SampleRate',Fs)); %'pchip' 'linear'
    All_speed = table2array(TT4(:,2:end));
    ss= [];
    acc= [];
    ss(:,1) = All_speed(:,1).^2+All_speed(:,3).^2+All_speed(:,2).^2;
    All_speed(:,11) = sqrt(ss);
    all_speeds = smoothdata(All_speed,1);
    acc(:,1:11) = diff(all_speeds)*Fs;
    
    Time2 = 3/Fs/2:1/Fs:length(All_speed)/Fs;
    time_ave2 = seconds(Time2)';
    TT5 = timetable(time_ave2,acc);
    TT6 = timetable2table(retime(TT5,'regular','pchip','SampleRate',Fs));
    All_acc = table2array(TT6(:,2:end));
    accs = smoothdata(All_acc,1);
    %%abs speed
    
    
    
%     [rho,pval] = corr(All_speed,All_data(:,11));
    
    %         for jj = 1:7
    %             figure(jj)
    %             plot(All_speed(:,jj),All_data(:,7));
    %         end
    %
    %         for jj = 1:7
    %             figure()
    %             plot(0.1:0.1:length(All_speed)*0.1,All_speed(:,jj));
    %             hold on;plot(0.1:0.1:length(All_speed)*0.1,All_data(:,7));hold off;
    %         end
    
    doulb_trig = find(diff(All_data(:,12)));
    del_trig = doulb_trig(find(diff(doulb_trig)==1)+1);
    [c, in]=setdiff(doulb_trig,del_trig);
    trig = doulb_trig(sort(in));                    %% +-0.0x s
    trig_time = diff(trig);
    
    
    %
    %     for kk=1:length(trig)-1
    %         figure(1);
    %         hold on;
    %         quiver3(All_data(trig(kk):trig(kk+1)-1,1),All_data(trig(kk):trig(kk+1)-1,3),All_data(trig(kk):trig(kk+1)-1,2),All_speed(trig(kk):trig(kk+1)-1,1),All_speed(trig(kk):trig(kk+1)-1,3),All_speed(trig(kk):trig(kk+1)-1,2));
    %         hold off;
    %     end
    %     figure(1);
    %     hold on;
    %     quiver3(All_data(trig(end):end,1),All_data(trig(end):end,3),All_data(trig(end):end,2),All_speed(trig(end):end,1),All_speed(trig(end):end,3),All_speed(trig(end):end,2));
    %     hold off;
    %
    
    subname = extractBefore(sub_name{1,iii},'.csv');                                 %{1,iii}
    savefilename=['VAS_',subname,'.mat'];
    save(['./VAS/',savefilename], 'time','All_data','trig','acc','accs','All_speed','all_speeds');           %G/I
    
end




