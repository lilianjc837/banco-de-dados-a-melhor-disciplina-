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

-- 4
delimiter //
create function media_livros_por_editora()
returns decimal(10, 2) deterministic
begin
    declare total_livros int default 0;
    declare total_editoras int default 0;
    declare editora_id int;
    declare done int default 0;
    
    declare cur_editora cursor for
        select editora_id from Editora;

declare continue handler for not found set done = 1;
    
    open cur_editora;
    
    loop_editoras: loop
        fetch cur_editora into editora_id;
        if done = 1 then
            leave loop_editoras;
        end if;
        
        open cur_livros;
        fetch cur_livros into total_livros;
        close cur_livros;
    end loop;

    close cur_editora;
    
    if total_editoras = 0 then
        return 0;
    else
        return total_livros / total_editoras;
    end if;

end //
delimiter ;

-- 5
delimiter //
create function autores_sem_livros()
returns varchar(500) deterministic
begin
    declare lista_autores_sem_livros varchar(500) default '';
    declare done int default 0;
    declare autor_id int;
    declare total_livros int default 0;
    
    declare cur_autores cursor for
        select autor_id, concat(primeiro_nome, ' ', ultimo_nome) as nome_autor
        from Autor;
    
    declare continue handler for not found set done = 1;
    
    open cur_autores;
    
    verificar_loop: loop
        fetch cur_autores into autor_id, nome_autor;
        if done = 1 then
            leave verificar_loop;
        end if;
        
        select count(*) into total_livros
        from Livro_Autor
        where autor_id = autor_id;
        
        if total_livros = 0 then
            if lista_autores_sem_livros = '' then
                set lista_autores_sem_livros = nome_autor;
            else
                set lista_autores_sem_livros = concat(lista_autores_sem_livros, ', ', nome_autor);
            end if;
        end if;
    end loop;
    
    close cur_autores;
    
    return lista_autores_sem_livros;
end //

delimiter ;
