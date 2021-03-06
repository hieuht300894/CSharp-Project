USE [ACCOUNT]
GO
/****** Object:  StoredProcedure [dbo].[spChiTietTK]    Script Date: 1/19/2015 7:51:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spChiTietTK]
@TenTaiKhoan nvarchar(20)
as
begin
	select TenTaiKhoan,TAIKHOAN.TinhTrang,CHUCVU.ChiTietChucVu from TAIKHOAN,CHUCVU where TAIKHOAN.MaChucVu=CHUCVU.MaChucVu and TenTaiKhoan=@TenTaiKhoan
end
GO
/****** Object:  StoredProcedure [dbo].[spChucVuCuaTaiKhoan]    Script Date: 1/19/2015 7:51:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[spChucVuCuaTaiKhoan]
@TenTaiKhoan nvarchar(20),
@MatKhau nvarchar(32)
as
begin
	if exists(select 1 from TAIKHOAN where TenTaiKhoan=@TenTaiKhoan and MatKhauTK=@MatKhau)
	begin
		select * 
		from TAIKHOAN,CHUCVU 
		where TenTaiKhoan=@TenTaiKhoan and TAIKHOAN.MaChucVu=CHUCVU.MaChucVu and MatKhauTK=@MatKhau
	end
	else
	begin
		raiserror('Sai tài khoản hoặc mật khẩu',1,1)
	end
end
GO
/****** Object:  StoredProcedure [dbo].[spChuyenChucVu]    Script Date: 1/19/2015 7:51:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spChuyenChucVu]
@TenTaiKhoan nvarchar(20),
@MaChucVu int
as
begin
	update TAIKHOAN set MaChucVu=@MaChucVu where TenTaiKhoan=@TenTaiKhoan
end
GO
/****** Object:  StoredProcedure [dbo].[spDoiMatKhau]    Script Date: 1/19/2015 7:51:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spDoiMatKhau]
@TenTaiKhoan nvarchar(20),
@MatKhau nvarchar(32)
as
begin
	update TAIKHOAN set MatKhauTK=@MatKhau where TenTaiKhoan=@TenTaiKhoan
end
GO
/****** Object:  StoredProcedure [dbo].[spDSChucVu]    Script Date: 1/19/2015 7:51:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spDSChucVu]
@TinhTrang int
as
begin
	if (@TinhTrang = 1)
		select * from CHUCVU where TinhTrang=@TinhTrang
	else
		select * from CHUCVU
end
GO
/****** Object:  StoredProcedure [dbo].[spDSPhanCong]    Script Date: 1/19/2015 7:51:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spDSPhanCong]
@MaChucVu int
as
begin
	select * from PHANCONG where MaChucVu=@MaChucVu
end

GO
/****** Object:  StoredProcedure [dbo].[spPhanCongViec]    Script Date: 1/19/2015 7:51:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Phân công việc
CREATE proc [dbo].[spPhanCongViec]
@MaChucVu int,
@TenDanhMuc nvarchar(32),
@ChiXem int,
@Them int,
@Sua int,
@Xoa int,
@TinhTrang int
as
begin
	if (@TinhTrang=0)
	begin
		update PHANCONG set ChiXem=0,Them=0,Sua=0,Xoa=0 where MaChucVu=@MaChucVu
		update TAIKHOAN set TinhTrang=0 where MaChucVu=@MaChucVu
	end
	else
	begin 
		declare @TenChucVu nvarchar(32)
		set @TenChucVu = (select TenChucVu from CHUCVU where MaChucVu=@MaChucVu)
		if (@ChiXem=1 and @Them=1 and @Sua=1 and @Xoa=1 and @TenDanhMuc='TK')
		begin
			exec sp_addsrvrolemember @TenChucVu,sysadmin
			update PHANCONG set ChiXem=1,Them=1,Sua=1,Xoa=1 where MaChucVu=@MaChucVu
		end
		else
		begin
			exec sp_dropsrvrolemember @TenChucVu,sysadmin
			update PHANCONG set ChiXem=@ChiXem,Them=@Them,Sua=@Sua,Xoa=@Xoa where MaChucVu=@MaChucVu and TenDanhMuc=@TenDanhMuc
		end
	end
	update CHUCVU set TinhTrang=@TinhTrang where MaChucVu=@MaChucVu
end

GO
/****** Object:  StoredProcedure [dbo].[spSuaTK]    Script Date: 1/19/2015 7:51:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spSuaTK]
@TenTaiKhoan nvarchar(20),
@TinhTrang int
as
begin
	update TAIKHOAN set TinhTrang=@TinhTrang where TenTaiKhoan=@TenTaiKhoan
end
GO
/****** Object:  StoredProcedure [dbo].[spTaoChucVu]    Script Date: 1/19/2015 7:51:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Tạo chức vụ
CREATE proc [dbo].[spTaoChucVu]
@loginame nvarchar(32),
@passwd nvarchar(32),
@MatKhauMaHoa nvarchar(100),
@ChiTietChucVu nvarchar(32)
as
begin
	if exists(select 1 from sys.sql_logins where name=@loginame)
	begin
		raiserror('Đã có chức vụ này rồi',1,1)
	end
	else
	begin
		exec sp_addlogin @loginame,@passwd
		declare @MaChucVu int
		set @MaChucVu=(select principal_id from sys.sql_logins where is_disabled=0 and name=@loginame)
		insert into CHUCVU values(@MaChucVu,@loginame,0,@ChiTietChucVu,@MatKhauMaHoa)
		insert into PHANCONG values(@MaChucVu,'SV',0,0,0,0)
		insert into PHANCONG values(@MaChucVu,'CSHT',0,0,0,0)
		insert into PHANCONG values(@MaChucVu,'DN',0,0,0,0)
		insert into PHANCONG values(@MaChucVu,'TB',0,0,0,0)
		insert into PHANCONG values(@MaChucVu,'KTKL',0,0,0,0)
		insert into PHANCONG values(@MaChucVu,'HD',0,0,0,0)
		insert into PHANCONG values(@MaChucVu,'TK',0,0,0,0)
	end
end

GO
/****** Object:  StoredProcedure [dbo].[spThemTaiKhoan]    Script Date: 1/19/2015 7:51:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spThemTaiKhoan]
@TenTaiKhoan nvarchar(20),
@MatKhau nvarchar(32),
@MaChucVu int
as
begin
	if exists(select 1 from TAIKHOAN where TenTaiKhoan=@TenTaiKhoan)
	begin
		raiserror('Đã có tài khoản này rồi',1,1)
	end
	else
	begin
		insert into TAIKHOAN values(@TenTaiKhoan,0,@MaChucVu,@MatKhau)
	end
end
GO
/****** Object:  StoredProcedure [dbo].[spXoaTK]    Script Date: 1/19/2015 7:51:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spXoaTK]
@TenTaiKhoan nvarchar(20)
as
begin
	if exists(select 1 from TAIKHOAN where TenTaiKhoan=@TenTaiKhoan and TinhTrang=0)
	begin
		delete TAIKHOAN where TenTaiKhoan=@TenTaiKhoan
	end
end

GO
