USE [QLKTXSPKT3]
GO
/****** Object:  StoredProcedure [dbo].[LoadDSMaPhong]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[LoadDSMaPhong]
@GioiTinh nvarchar(3)
as
begin
	select MaPhong
	from PHONG,TANG 
	where	SoLuongHienTai<SoLuongMax and SoLuongMax>0 and
			PHONG.MaTang=TANG.MaTang and
			LoaiTang=@GioiTinh 
end
GO
/****** Object:  StoredProcedure [dbo].[sp_ChiTietTB]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- load chi tiet thiet bi
create proc [dbo].[sp_ChiTietTB]
@tentb nvarchar(30)
as
begin
	select TenTB, DonGia from THIETBI
	where TenTB=@tentb
end
GO
/****** Object:  StoredProcedure [dbo].[sp_chitietTN]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- than nhan
create proc [dbo].[sp_chitietTN]
@MSSV int
as
begin
	 select HoTenTN, QuanHe,NgheNghiep,THANNHAN.SDT,HoKhau, THANNHAN.MSSV
	 from SINHVIEN inner join THANNHAN on SINHVIEN.MSSV= THANNHAN.MSSV
	 where THANNHAN.MSSV=@MSSV
end

GO
/****** Object:  StoredProcedure [dbo].[sp_ChuyenPhongSV]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_ChuyenPhongSV]
@MSSV int,
@MaPhong char(6),
@NgayCap date
as
 begin
	declare @MaPhongCu char(6)
	set @MaPhongCu=(select MaPhong From CAPPHONG where MSSV=@MSSV and TinhTrang=1)
	UPDATE CAPPHONG
	set MaPhong=@MaPhong, NgayCap=@NgayCap
	where MSSV=@MSSV and TinhTrang=1 
	update PHONG
	set SoLuongHienTai = SoLuongHienTai+1 where MaPhong= @MaPhong
	update PHONG
	set SoLuongHienTai = SoLuongHienTai-1 where MaPhong= @MaPhongCu


 end

GO
/****** Object:  StoredProcedure [dbo].[sp_danhsachTB]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- load danh sach thiet bi
create proc [dbo].[sp_danhsachTB]
as
begin
	 select THIETBI.TenTB, THIETBI.DonGia
	 from THIETBI
end
--exec sp_danhsachTB

GO
/****** Object:  StoredProcedure [dbo].[sp_danhsachthietbi]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_danhsachthietbi]
as
begin
	select MaTB,TenTB from THIETBI
end
GO
/****** Object:  StoredProcedure [dbo].[sp_DSSVChuaCapPhong]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- danh sach sinh vien chua cap phong
CREATE proc [dbo].[sp_DSSVChuaCapPhong]
@MSSV int
as
begin
	select * from CAPPHONG where  MSSV=@MSSV and TinhTrang=1
end
--exec sp_DSSVChuaCapPhong

GO
/****** Object:  StoredProcedure [dbo].[sp_DSSVMP]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- load sinh vien theo ma phong load sau khi chuyen
create proc  [dbo].[sp_DSSVMP]
@MaPhong char(6)
as
begin 
	select  CAPPHONG.MSSV, HoTen, GioiTinh , NienKhoa, MaPhong
	from SINHVIEN, CAPPHONG
	where CAPPHONG.MSSV=SINHVIEN.MSSV and CAPPHONG.TinhTrang=1 and MaPhong=@MaPhong
end


--exec sp_DSSVMP D10301

GO
/****** Object:  StoredProcedure [dbo].[sp_DSTBPhong]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_DSTBPhong]
@MaPhong char(6)
as
begin
	select QLTBPHONG.MaPhong,TenTB,SoLuong,MoTa,Nam 
	from QLTBPHONG,THIETBI
	where QLTBPHONG.MaTB=THIETBI.MaTB and QLTBPHONG.MaPhong=@MaPhong
end
GO
/****** Object:  StoredProcedure [dbo].[sp_LayMP]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_LayMP]
as
begin
	select MaPhong from PHONG
end
GO
/****** Object:  StoredProcedure [dbo].[sp_loadchitietSV]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- chi tiety sinh vien
CREATE proc [dbo].[sp_loadchitietSV]
@MSSV int
as
begin
	select *
	from SINHVIEN
	where MSSV=@MSSV
end

GO
/****** Object:  StoredProcedure [dbo].[sp_loadSV]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec sp_ChuyenPhongSV 12110022,D10302

-- load danh sav sinh vien
CREATE proc  [dbo].[sp_loadSV]
@tinhtrang int
as
begin 
	select SINHVIEN.MSSV,HoTen,GioiTinh,MaPhong
	from SINHVIEN,CAPPHONG
	where SINHVIEN.TinhTrang=@tinhtrang and  SINHVIEN.MSSV=CAPPHONG.MSSV
end

GO
/****** Object:  StoredProcedure [dbo].[sp_MaPhongDaDcCap]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_MaPhongDaDcCap]
as
begin
	select MaPhong from PHONG where exists(select MaPhong from QLTBPHONG where QLTBPHONG.MaPhong=PHONG.MaPhong)
end

GO
/****** Object:  StoredProcedure [dbo].[sp_SuaTB]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- sua  thông tin thiet bi
create proc [dbo].[sp_SuaTB]
@tentb nvarchar(30),
@dongia int
as
begin 
update THIETBI
set TenTB=@tentb, DonGia=@dongia
where TenTB=@tentb
end


GO
/****** Object:  StoredProcedure [dbo].[sp_suaTN]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- sua than nhan 
create proc [dbo].[sp_suaTN]
@HoTenTN nvarchar(30),
@QuanHe nvarchar(10),
@NgheNghiep nvarchar(30),
@SDT varchar(11),
@MSSV int
as
begin 
	 update THANNHAN
	 set HoTenTN=@HoTenTN,QuanHe=@QuanHe,NgheNghiep=@NgheNghiep,SDT=@SDT,MSSV=@MSSV
	 where MSSV=@MSSV
end

GO
/****** Object:  StoredProcedure [dbo].[sp_themsinhvien]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[sp_themsinhvien]
@MSSV int, 
@HoTen nvarchar(30),
@GioiTinh nvarchar(3),
@CMND int,
@ngaysinh date,
@NienKhoa char(9),
@HoKhau nvarchar(80),
@SDT varchar(11),
@DienUuTien nvarchar(30),
@TinhTrang int,
@GhiChu  nvarchar(max)
as
begin
	if exists(select 1 from SINHVIEN where MSSV=@MSSV)
	begin
		raiserror('Da ton tai sv nay',1,1)
	end
	else
	begin
		insert into SINHVIEN values( @MSSV, @HoTen, @GioiTinh, @CMND, @NgaySinh, @NienKhoa, @HoKhau, @SDT, @DienUuTien, @TinhTrang,@GhiChu )
	end
end
--exec sp_themsinhvien 12110055,N'Hiếu',N'Nam',272111111,'08-30-1994','2012-2016',N'Đồng Nai',09311223344,N'Không',1,null

GO
/****** Object:  StoredProcedure [dbo].[sp_themTB]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- them thong tin thiet bi
create proc [dbo].[sp_themTB]
@tenTB nvarchar(30),
@DonGia int
as
begin 
	insert into THIETBI values (@tenTB, @DonGia)
end

GO
/****** Object:  StoredProcedure [dbo].[sp_ThemThietBi]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create  proc [dbo].[sp_ThemThietBi]
@maTB int,
@maphong char(6),
@soluong int,
@mota nvarchar(30),
@nam date
as
begin
	insert into QLTBPHONG values(@maTB,@maphong,@soluong,@mota,@nam)
end
GO
/****** Object:  StoredProcedure [dbo].[sp_themTN]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_themTN]
@HoTenTN nvarchar(30),
@QuanHe nvarchar(10),
@NgheNghiep nvarchar(30),
@SDT varchar(11),
@MSSV int 
  as
  begin
	insert into THANNHAN values(@HoTenTN,@QuanHe,@NgheNghiep,@SDT,@MSSV)
  end

GO
/****** Object:  StoredProcedure [dbo].[sp_xoasinhvien]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_xoasinhvien]
@MSSV int
as
begin
	update SINHVIEN
	set TinhTrang=0
	where MSSV=@MSSV 
	update CAPPHONG
	set TinhTrang=0
	where MSSV=@MSSV
	update PHONG 
	set SoLuongHienTai=SoLuongHienTai-1 
	where MaPhong = (select MaPhong from CAPPHONG 
			where MSSV=@MSSV)
end
GO
/****** Object:  StoredProcedure [dbo].[spCapNhatDienNuoc]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spCapNhatDienNuoc]
@maphong char(6),
@ngayghi date,
@sodiencuoi int,
@sonuoccuoi int,
@tinhtrang int
as
begin
	--Lấy mã định mức cần tính
	declare @madn int
	set @madn =(select DIENNUOC.MaDienNuoc
				from DIENNUOC
				where MaPhong=@maphong and MONTH(NgayGhi)=MONTH(@ngayghi) and Year(NgayGhi)=Year(@ngayghi))

	--Tinh tien dien
	declare @tongtiendien int
	set @tongtiendien=0
	
	declare @tongdien int
	set @tongdien=@sodiencuoi-(select DIENNUOC.SoDienDau from DIENNUOC where MaDienNuoc=@madn)

	if (@tongdien between 0 and 100)
		set @tongtiendien=(select DINHMUC.SoTien from DINHMUC where GhiChu ='0-100 kW')*@tongdien
	else
	begin
		if (@tongdien between 101 and 200)			
			set @tongtiendien = (select DINHMUC.SoTien from DINHMUC where GhiChu='101-200 kW')*(@tongdien-100)
						  +	(select DINHMUC.SoTien from DINHMUC where GhiChu='0-100 kW')*100
		else
		begin
			if (@tongdien between 201 and 300)			
				set @tongtiendien = (select DINHMUC.SoTien from DINHMUC where GhiChu='201-300 kW')*(@tongdien-200)
							  + (select DINHMUC.SoTien from DINHMUC where GhiChu='101-200 kW')*100
						      +	(select DINHMUC.SoTien from DINHMUC where GhiChu='0-100 kW')*100
			else
			begin
				if (@tongdien between 301 and 400)			
					set @tongtiendien = (select DINHMUC.SoTien from DINHMUC where GhiChu='301-400 kW')*(@tongdien-300)
							+  (select DINHMUC.SoTien from DINHMUC where GhiChu='201-300 kW')*100
							+  (select DINHMUC.SoTien from DINHMUC where GhiChu='101-200 kW')*100
						    +  (select DINHMUC.SoTien from DINHMUC where GhiChu='0-100 kW')*100
				else
				begin
					if (@tongdien between 401 and 500)			
						set @tongtiendien = (select DINHMUC.SoTien from DINHMUC where GhiChu='401-500 kW')*(@tongdien-400)
						    +  (select DINHMUC.SoTien from DINHMUC where GhiChu='301-400 kW')*100
							+  (select DINHMUC.SoTien from DINHMUC where GhiChu='201-300 kW')*100
							+  (select DINHMUC.SoTien from DINHMUC where GhiChu='101-200 kW')*100
						    +  (select DINHMUC.SoTien from DINHMUC where GhiChu='0-100 kW')*100
					else
					begin		
						set @tongtiendien = (select DINHMUC.SoTien from DINHMUC where GhiChu='>501 kW')*(@tongdien-500)
							+  (select DINHMUC.SoTien from DINHMUC where GhiChu='401-500 kW')*100
						    +  (select DINHMUC.SoTien from DINHMUC where GhiChu='301-400 kW')*100
							+  (select DINHMUC.SoTien from DINHMUC where GhiChu='201-300 kW')*100
							+  (select DINHMUC.SoTien from DINHMUC where GhiChu='101-200 kW')*100
						    +  (select DINHMUC.SoTien from DINHMUC where GhiChu='0-100 kW')*100
					end
				end
			end
		end
	end

	--Tinh tien nuoc
	declare @tongtiennuoc int
	set @tongtiennuoc=0

	declare @tongnuoc int
	set @tongnuoc=@sonuoccuoi-(select DIENNUOC.SoNuocDau from DIENNUOC where MaDienNuoc=@madn)

	if (@tongnuoc between 0 and 4)
		set @tongtiennuoc=(select DINHMUC.SoTien from DINHMUC where GhiChu='0-4 m3')*@tongnuoc
	else
	begin
		if (@tongnuoc between 5 and 6)			
			set @tongtiennuoc = (select DINHMUC.SoTien from DINHMUC where GhiChu='4-6 m3')*(@tongnuoc-4)
						  +	(select DINHMUC.SoTien from DINHMUC where GhiChu='0-4 m3')*4
		else			
				set @tongtiennuoc = (select DINHMUC.SoTien from DINHMUC where GhiChu='>6 m3')*(@tongnuoc-6)
							  + (select DINHMUC.SoTien from DINHMUC where GhiChu='4-6 m3')*2
						      +	(select DINHMUC.SoTien from DINHMUC where GhiChu='0-4 m3')*4
	end

	if (@tinhtrang = 0)
		update DIENNUOC 
		set SoDienCuoi=@sodiencuoi,SoNuocCuoi=@sonuoccuoi,TongTien=@tongtiendien+@tongtiennuoc
		where MaDienNuoc=@madn
	else
		update DIENNUOC 
		set SoDienCuoi=@sodiencuoi,SoNuocCuoi=@sonuoccuoi,TongTien=@tongtiendien+@tongtiennuoc,TinhTrang=@tinhtrang
		where MaDienNuoc=@madn

	insert into DIENNUOC values(DATEADD(MONTH,1,@ngayghi),@sodiencuoi,@sonuoccuoi,0,0,0,0,@maphong)
end


GO
/****** Object:  StoredProcedure [dbo].[spCapPhong]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--cap phong
create proc [dbo].[spCapPhong]
@MSSV int,
@MaPhong char(6),
@NgayCap date
as
begin

	insert into CAPPHONG values(@MSSV,@MaPhong,@NgayCap,1)
	update PHONG set SoLuongHienTai=SoLuongHienTai+1 where MaPhong=@MaPhong
end



GO
/****** Object:  StoredProcedure [dbo].[spChiTietDNCuaPhong]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spChiTietDNCuaPhong]
@MaPhong char(6),
@ngaybatdau date,
@ngayketthuc date
as
begin
	select * 
	from DIENNUOC 
	where MaPhong=@MaPhong and TinhTrang=1  and NgayGhi between @ngaybatdau and @ngayketthuc
end
GO
/****** Object:  StoredProcedure [dbo].[spDongTienDienNuoc]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spDongTienDienNuoc]
@MaPhong char(6),
@ngayghi date
as
begin
	update DIENNUOC set TinhTrang = 1 where  MONTH(NgayGhi)=MONTH(@ngayghi) and Year(NgayGhi)=Year(@ngayghi) and MaPhong=@MaPhong
end	
GO
/****** Object:  StoredProcedure [dbo].[spDSCoSo]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spDSCoSo]
as
begin
	select * from COSO
end

GO
/****** Object:  StoredProcedure [dbo].[spDSDienNuoc]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spDSDienNuoc]
@MaDM char(1)
as
begin
	select * from DINHMUC where MaDinhMuc like @MaDM + '%'
end
GO
/****** Object:  StoredProcedure [dbo].[spDSHinhThuc]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spDSHinhThuc]
@chon int
as
begin
	if (@chon=0)
	begin
		select * from HINHTHUC where KieuHT='KT'
	end
	else if (@chon=1)
	begin
		select * from HINHTHUC where KieuHT='KL'
	end
	else
	begin
		select * from HINHTHUC
	end
end

GO
/****** Object:  StoredProcedure [dbo].[spDSPhong]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spDSPhong]
@MaTang char(4),
@KhoaChon int
as
begin
	if (@KhoaChon = 0)		--Phòng còn trống
		select MaPhong,TruongPhong,SoLuongMax,SoLuongHienTai from PHONG where MaTang=@MaTang and SoLuongHienTai=0
	else if (@KhoaChon = 1) --Phòng đang sử dụng
		select MaPhong,TruongPhong,SoLuongMax,SoLuongHienTai from PHONG where MaTang=@MaTang and SoLuongHienTai>0
	else					--Tất cả
		select MaPhong,TruongPhong,SoLuongMax,SoLuongHienTai from PHONG where MaTang=@MaTang
end

GO
/****** Object:  StoredProcedure [dbo].[spDSPhongChuaCapNhatDNTrongThang]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spDSPhongChuaCapNhatDNTrongThang]
@ngayghi date
as
begin
	select * from DIENNUOC where MONTH(NgayGhi)=MONTH(@ngayghi) and Year(NgayGhi)=Year(@ngayghi) and SoDienCuoi=0 and SoNuocCuoi=0
end
GO
/****** Object:  StoredProcedure [dbo].[spDSPhongChuaDongTien]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spDSPhongChuaDongTien]
@ngayghi date
as
begin
	select MaDienNuoc,MaPhong,TongTien
	from DIENNUOC
	where TinhTrang=0 and TongTien>0 and MONTH(NgayGhi)=MONTH(@ngayghi) and Year(NgayGhi)=Year(@ngayghi)
end
GO
/****** Object:  StoredProcedure [dbo].[spDSPhongChuaThemChiSoLanDau]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spDSPhongChuaThemChiSoLanDau]
as
begin
	select * from PHONG where not exists (select DIENNUOC.MaPhong from DIENNUOC where DIENNUOC.MaPhong=PHONG.MaPhong)
end
GO
/****** Object:  StoredProcedure [dbo].[spDSTang]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spDSTang]
@MaCoSo char(2)
as
begin
	select MaTang,LoaiTang,TruongTang from TANG where MaCoSo=@MaCoSo
end

GO
/****** Object:  StoredProcedure [dbo].[spHinhThuc]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spHinhThuc]
@Chon int,
@MaHT int,
@TenHT nvarchar(20),
@MoTa nvarchar(100),
@KieuHT char(2)
as
begin
	if (@Chon=-1)
	begin
		insert into HINHTHUC values(@KieuHT,@TenHT,@MoTa)
	end
	else if (@Chon=0)
	begin
		update HINHTHUC
		set KieuHT=@KieuHT,TenHT=@TenHT,MoTa=@MoTa
		where MaHT=@MaHT
	end
	else
	begin
		delete HINHTHUC where MaHT=@MaHT
	end
end

GO
/****** Object:  StoredProcedure [dbo].[spSuaCoSo]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spSuaCoSo]
@MaCoSo char(2),
@DiaDiem nvarchar(80)
as
begin
	update COSO set DiaDiem=@DiaDiem where MaCoSo=@MaCoSo
end

GO
/****** Object:  StoredProcedure [dbo].[spSuaGiaDienNuoc]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spSuaGiaDienNuoc]
@MaDM char(2),
@sotien int
as
begin
	update DINHMUC set SoTien=@sotien where MaDinhMuc=@MaDM
end

GO
/****** Object:  StoredProcedure [dbo].[spSuaPhong]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spSuaPhong]
@MaPhong char(6),
@TruongPhong int,
@SoLuongMax int
as
begin
	if (select PHONG.SoLuongHienTai from PHONG where MaPhong=@MaPhong) <= @SoLuongMax
		if (@TruongPhong > 0)
			update PHONG set TruongPhong=@TruongPhong,SoLuongMax=@SoLuongMax where MaPhong=@MaPhong
		else
			update PHONG set TruongPhong=null,SoLuongMax=@SoLuongMax where MaPhong=@MaPhong
end

GO
/****** Object:  StoredProcedure [dbo].[spSuaTang]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spSuaTang]
@MaTang char(4),
@LoaiTang nvarchar(3),
@TruongTang int
as
begin
	if (@TruongTang < 0)
		update TANG set LoaiTang=@LoaiTang,TruongTang=null where MaTang=@MaTang
	else
		update TANG set LoaiTang=@LoaiTang,TruongTang=@TruongTang where MaTang=@MaTang
end

GO
/****** Object:  StoredProcedure [dbo].[spThemChiSoLanDau]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spThemChiSoLanDau]
@MaPhong char(6),
@ngayghi date,
@sodiendau int,
@sonuocdau int
as
begin
	insert into DIENNUOC values(@ngayghi,@sodiendau,@sonuocdau,0,0,0,0,@MaPhong)
end
GO
/****** Object:  StoredProcedure [dbo].[spThemCoSo]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spThemCoSo]
@MaCoSo char(2),
@DiaDiem nvarchar(80)
as
begin
	insert into COSO values(@MaCoSo,@DiaDiem)
end

GO
/****** Object:  StoredProcedure [dbo].[spThemPhong]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spThemPhong]
@MaPhong char(2),
@TruongPhong int,
@SoLuongMax int,
@MaTang char(4)
as
begin
	if (@TruongPhong > 0)
		insert into PHONG values(@MaTang+@MaPhong,@TruongPhong,@SoLuongMax,0,@MaTang)
	else
		insert into PHONG values(@MaTang+@MaPhong,null,@SoLuongMax,0,@MaTang)
end

GO
/****** Object:  StoredProcedure [dbo].[spThemTang]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spThemTang]
@MaTang char(2),
@LoaiTang nvarchar(3),
@TruongTang int,
@MaCoSo char(2)
as
begin
	if (@TruongTang < 0)
		insert into TANG values(@MaCoSo+@MaTang,@LoaiTang,null,@MaCoSo)
	else
		insert into TANG values(@MaCoSo+@MaTang,@LoaiTang,@TruongTang,@MaCoSo)
end

GO
/****** Object:  StoredProcedure [dbo].[spTongHopSoTienTheoNgay]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spTongHopSoTienTheoNgay]
@ngaybatdau date,
@ngayketthuc date
as
begin
	if (@ngaybatdau<@ngayketthuc)
		select SUM(TongTien) as SoTien ,SUM(SoDienCuoi-SoDienDau)as SoDien ,SUM(SoNuocCuoi-SoNuocDau)as SoNuoc
		from DIENNUOC 
		where TinhTrang=1 and NgayGhi between @ngaybatdau and @ngayketthuc
end

GO
/****** Object:  StoredProcedure [dbo].[spXemTongTienTheoNgay]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spXemTongTienTheoNgay]
@ngaybatdau date,
@ngayketthuc date
as
begin
	if (@ngaybatdau<@ngayketthuc)
		select DIENNUOC.MaPhong,SUM(TongTien) as SoTien, SUM(SoDienCuoi-SoDienDau)as SoDien ,SUM(SoNuocCuoi-SoNuocDau)as SoNuoc
		from DIENNUOC 
		where TinhTrang=1 and NgayGhi between @ngaybatdau and @ngayketthuc
		group by MaPhong 
	end

GO
/****** Object:  StoredProcedure [dbo].[SuaTTSinhVien]    Script Date: 1/19/2015 7:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- sua sinh vien
create proc [dbo].[SuaTTSinhVien]
@MSSV int, 
@HoTen nvarchar(30),
@GioiTinh nvarchar(3),
@CMND int,
@ngaysinh date,
@NienKhoa char(9),
@HoKhau nvarchar(80),
@SDT varchar(11),
@DienUuTien nvarchar(30),
@TinhTrang int,
@GhiChu  nvarchar(max)
as
begin
	update SINHVIEN 
	set MSSV=@MSSV, HoTen=@HoTen, GioiTinh=@GioiTinh, CMND= @CMND, NgaySinh=@ngaysinh, NienKhoa=@NienKhoa, HoKhau=@HoKhau,SDT=@SDT, DienUuTien=@DienUuTien,TinhTrang=@TinhTrang,Ghichu=@GhiChu
	where MSSV=@MSSV
end

GO
