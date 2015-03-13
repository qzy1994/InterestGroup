%get stock data from ifeng finance
num = 'sz002291';
year = 2014;
%month = 2;
t = [];date_t =[];
for month = 1:12
    [webfile,status] = urlread(sprintf('http://app.finance.ifeng.com/data/stock/tab_zjlx.php?code=sz002291&begin_day=2014-%d-1&end_day=2014-%d-31',month,month));
        if ~status
            error('can not read url');
            continue;
        end

    expr1 = '>(\d\d\d\d-\d\d-\d\d)</td>'; %日期
    [date_info,date_tokens] = regexp(webfile,expr1,'match','tokens');

    expr2 = '>(\W?\d+\.?\d*)万元';%交易额
    [money,money_tokens] = regexp(webfile,expr2,'match','tokens');

    expr3 = '>(\W?\d+\.?\d*)%';%涨跌幅
    [updown,updown_tokens] = regexp(webfile,expr3,'match','tokens');

    date = [];
    for idx = 1:length(date_tokens)
        date =[date; date_tokens{idx}];
    end
    date = date(:);
    date = flipud(date);

    transaction = [];
    for idx = 1:length(money_tokens)-5
        if mod(idx,6) == 0
            col = 6;
            row = idx/6;
        else
            col = mod(idx,6);
            row = fix(idx/6)+1;
        end
        transaction(row,col) =  str2double(money_tokens{idx});
    end
    transaction = flipud(transaction);
        
    updowns = [];
    for idx = 1:length(updown_tokens)
        updowns = [updowns;str2double(updown_tokens{idx})];
    end
    updowns = flipud(updowns);
    total = [transaction,updowns];
    t = [t;total];
    date_t = [date_t;char(date)];
end
name = sprintf('%s',num);
xlswrite(name,date_t);
xlswrite(name,t,'','B1');

