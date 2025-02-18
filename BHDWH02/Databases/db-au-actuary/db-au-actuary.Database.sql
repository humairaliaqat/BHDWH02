USE [master]
GO
/****** Object:  Database [db-au-actuary]    Script Date: 18/02/2025 12:14:25 PM ******/
CREATE DATABASE [db-au-actuary]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'db-au-actuary', FILENAME = N'E:\SQLData\db-au-actuary.mdf' , SIZE = 1695810560KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'db-au-actuary_log', FILENAME = N'F:\SQLLog\db-au-actuary_log.ldf' , SIZE = 47216768KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [db-au-actuary] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [db-au-actuary].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [db-au-actuary] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [db-au-actuary] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [db-au-actuary] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [db-au-actuary] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [db-au-actuary] SET ARITHABORT OFF 
GO
ALTER DATABASE [db-au-actuary] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [db-au-actuary] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [db-au-actuary] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [db-au-actuary] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [db-au-actuary] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [db-au-actuary] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [db-au-actuary] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [db-au-actuary] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [db-au-actuary] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [db-au-actuary] SET  DISABLE_BROKER 
GO
ALTER DATABASE [db-au-actuary] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [db-au-actuary] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [db-au-actuary] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [db-au-actuary] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [db-au-actuary] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [db-au-actuary] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [db-au-actuary] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [db-au-actuary] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [db-au-actuary] SET  MULTI_USER 
GO
ALTER DATABASE [db-au-actuary] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [db-au-actuary] SET DB_CHAINING OFF 
GO
ALTER DATABASE [db-au-actuary] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [db-au-actuary] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'db-au-actuary', N'ON'
GO
ALTER DATABASE [db-au-actuary] SET  READ_WRITE 
GO
