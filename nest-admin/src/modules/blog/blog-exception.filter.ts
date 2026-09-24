import { ArgumentsHost, Catch, ExceptionFilter, HttpException } from '@nestjs/common';

/** Keep auth/password payloads out of error responses, including development mode. */
@Catch(HttpException)
export class BlogExceptionFilter implements ExceptionFilter {
  catch(error: HttpException, host: ArgumentsHost) {
    const status = error.getStatus();
    host.switchToHttp().getResponse().status(status).json({ code: status, message: error.message });
  }
}
