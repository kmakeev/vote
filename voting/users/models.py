from django.db import models
from django.utils import timezone
from rest_framework import serializers
# from django.contrib.auth.models import User as DjangoUser
from rest_framework.validators import UniqueTogetherValidator
from django.contrib.auth import get_user_model
from django.contrib.auth.models import (
    BaseUserManager, AbstractBaseUser, PermissionsMixin
)


class UserManager(BaseUserManager):

    def create_user(self, username, email, password=None, **kwargs):
        if not email:
            raise ValueError('Users must have an Email')

        user = self.model(username=username,
            email=self.normalize_email(email), **kwargs)

        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, username, email, password):
        """
        Creates and saves a superuser with the given email and password.
        """
        user = self.create_user(
            username=username,
            email=email,
            password=password
        )
        user.is_admin = True
        user.save(using=self._db)
        return user


class MyUser(AbstractBaseUser, PermissionsMixin):
    email = models.EmailField(max_length=255, unique=True)
    username = models.CharField('Логин', max_length=255, blank=True, null=True)
    first_name = models.CharField('Фамилия', max_length=255, blank=True, null=True)
    last_name = models.CharField('Имя', max_length=255, blank=True, null=True)
    sur_name = models.CharField('Отчество', max_length=255, blank=True, null=True)
    date_of_birth = models.DateField(verbose_name="Дата рождения", null=True, blank=True)
    last_time_visit = models.DateTimeField(default=timezone.now)
    is_active = models.BooleanField(default=True)
    is_admin = models.BooleanField(default=False)

    objects = UserManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username']

    def __str__(self):
        return self.email

    def has_perm(self, perm, obj=None):
        return True

    def has_module_perms(self, app_label):
        return True

    @property
    def is_staff(self):
        return self.is_admin


class MyUserSerializer(serializers.ModelSerializer):

    def create(self, validated_data):
        user = MyUser.objects.create_user(**validated_data)
        return user

    class Meta:
        model = MyUser
        fields = (
            'username',
            'first_name',
            'last_name',
            'sur_name',
            'is_active',
            'is_admin',
            'email',
            # 'password',
        )
        validators = [
            UniqueTogetherValidator(queryset=MyUser.objects.all(),
                                    fields=['username', 'email'])
        ]


class MyUserShortSerializer(serializers.ModelSerializer):

    def create(self, validated_data):
        user = MyUser.objects.create_user(**validated_data)
        return user

    class Meta:
        model = MyUser
        fields = (
            'id',
            'is_admin',
        )
