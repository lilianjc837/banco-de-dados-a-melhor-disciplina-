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

-- 2
delimiter //
create function listar_livros_por_autor(primeiro_nome_autor varchar(200), ultimo_nome_autor varchar(200))
returns text deterministic
begin
    declare lista_de_livros text default '';
    declare done int default 0;
    declare livro_id int;
    
    declare cur cursor for
        select la.livro_id
        from Livro_Autor la
        join Autor a on la.autor_id = a.autor_id
        where a.primeiro_nome = primeiro_nome_autor
        and a.ultimo_nome = ultimo_nome_autor;

    declare continue handler for not found set done = 1;

    open cur;

    livros_loop: loop
        fetch cur into livro_id;
        if done = 1 then
            leave livros_loop;
        end if;

        select group_concat(titulo) into lista_de_livros
        from Livro
        where livro_id = livro_id;
    end loop;

    close cur;

    return lista_de_livros;
end //
delimiter ;

-- 3
delimiter //
create function atualizar_resumos()
returns int deterministic
begin
    declare done int default 0;
    declare livro_id int;
    declare resumo_atual varchar(1000);
    declare novo_resumo varchar(1000);
    
    declare cur cursor for
        select livro_id, resumo from Livro;
    
    declare continue handler for not found set done = 1;
    
    open cur;
    
    resumo_loop: loop
        fetch cur into livro_id, resumo_atual;
        if done = 1 then
            leave resumo_loop;
        end if;
        
        set novo_resumo = concat(resumo_atual, ' Este é um excelente livro!');
        
        update Livro
        set resumo = novo_resumo
        where livro_id = livro_id;
    end loop;
    
    close cur;
    
    return 1;
end //

delimiter ;
