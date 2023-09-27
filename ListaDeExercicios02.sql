DELIMITER // 
create procedure sp_ListarAutores()
begin
    select * from autor;
end;
//
DELIMITER ;

call sp_ListarAutores();

-- 2
delimiter //
create procedure sp_livros_por_categoria(in categoria_nome varchar(100))
begin
    select livro.titulo
    from livro
    inner join categoria on livro.categoria_id = categoria.categoria_id
    where categoria.nome = categoria_nome;
end;
//
delimiter ;

call sp_livros_por_categoria('Romance');
call sp_livros_por_categoria('Ficção científica');

-- 3
delimiter //
create procedure sp_contar_livros_por_categoria(in categoria_nome varchar(100), out total_livros int)
begin
    select count(*) into total_livros
    from livro
    inner join categoria on livro.categoria_id = categoria.categoria_id
    where categoria.nome = categoria_nome;
end;
//
delimiter ;
call sp_contar_livros_por_categoria('História', @total);
select @total;
