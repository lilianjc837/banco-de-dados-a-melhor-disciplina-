DELIMITER // 
create procedure sp_ListarAutores()
begin
    select * from autor;
end;
//
DELIMITER ;

call sp_ListarAutores();
