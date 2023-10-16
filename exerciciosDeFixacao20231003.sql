-- 1
delimiter //
create function total_livros_por_genero(nome_genero varchar(255))
returns int deterministic
begin
    declare total int default 0;
    declare done int default 0;
    declare livro_id int;
    
    declare cur cursor for
        select livro_id from livros where genero = nome_genero;
    
    declare continue handler for not found set done = 1;
    
    open cur;
    
    livros_loop: loop
        fetch cur into livro_id;
        if done = 1 then
            leave livros_loop;
        end if;
        set total = total + 1;
    end loop;
    
    close cur;
    
    return total;
end //
delimiter ;
