collect1 = make_empty_struct_from_cell(fieldnames(match1.match));
fields = fieldnames(match1.match);
for i_field=1:numel(fields)
    fieldnamecell = fields(i_field);
    fieldname = fieldnamecell{1};
    for i_day = 1:numel(match1.match)
        if size(fieldname,2) > 2 && all(fieldname(1:3) == 'cas') && offset >= 0
            collect1.(fields{i_field}) = cat(2, collect1.(fields{i_field}), match1.match(i_day).(fields{i_field})(1+offset:end));
        elseif size(fieldname,2) > 2 && all(fieldname(1:3) == 'cas') && offset < 0
            collect1.(fields{i_field}) = cat(2, collect1.(fields{i_field}), match1.match(i_day).(fields{i_field})(1:end+offset));
        elseif offset >= 0
            collect1.(fields{i_field}) = cat(2, collect1.(fields{i_field}), match1.match(i_day).(fields{i_field})(1:end-offset));
        else
            collect1.(fields{i_field}) = cat(2, collect1.(fields{i_field}), match1.match(i_day).(fields{i_field})(1-offset:end));
        end
    end
end